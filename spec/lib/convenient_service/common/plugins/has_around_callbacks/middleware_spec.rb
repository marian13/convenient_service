# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasAroundCallbacks::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for any_method, scope: any_scope
        end
      end

      it "returns intended methods" do
        expect(described_class.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }

      let(:out) { Tempfile.new }
      let(:output) { out.tap(&:rewind).read }
      let(:result_original_value) { "result original value" }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(result_original_value, out) do |result_original_value, out|
            include ConvenientService::Common::Plugins::HasCallbacks::Concern
            include ConvenientService::Common::Plugins::HasAroundCallbacks::Concern

            define_method(:out) { out }

            define_method(:result) { result_original_value.tap { out.puts "original result" } }
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify {
        expect { method_value }
          .to call_chain_next.on(method)
          .and_return_its_value
      }

      context "when service class has no callbacks" do
        let(:text) do
          <<~TEXT
            original result
          TEXT
        end

        it "runs only middleware `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has one around callback" do
        let(:text) do
          <<~TEXT
            first around before result
            original result
            first around after result
          TEXT
        end

        before do
          service_class.around(:result) do |chain|
            out.puts "first around before result"

            chain.yield

            out.puts "first around after result"
          end
        end

        it "runs that around callback in addition to middleware `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has multiple around callbacks" do
        let(:text) do
          <<~TEXT
            first around before result
            second around before result
            original result
            second around after result
            first around after result
          TEXT
        end

        before do
          service_class.around(:result) do |chain|
            out.puts "first around before result"

            chain.yield

            out.puts "first around after result"
          end

          service_class.around(:result) do |chain|
            out.puts "second around before result"

            chain.yield

            out.puts "second around after result"
          end
        end

        it "runs that around callback in addition to middleware `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      example_group "after callbacks first argument" do
        before do
          service_class.after(:result) { |result| result.success? }
        end

        it "passes middleware `chain.next` to all after callbacks as first argument" do
          expect { method_value }.not_to raise_error
        end
      end

      example_group "callback `chain.yield` return value in around callbacks" do
        before do
          service_class.around(:result) do |chain|
            out.puts "first around before result"

            result = chain.yield

            ##
            # NOTE: `result_original_value` is NOT available inside service instance context.
            # That is why "result original value" literal is used.
            #
            raise if result != "result original value"

            out.puts "first around after result"
          end

          service_class.around(:result) do |chain|
            out.puts "second around before result"

            result = chain.yield

            ##
            # NOTE: `result_original_value` is NOT available inside service instance context.
            # That is why "result original value" literal is used.
            #
            raise if result != "result original value"

            out.puts "second around after result"
          end
        end

        it "passes middleware `chain.next` to all after callbacks as first argument" do
          expect { method_value }.not_to raise_error
        end
      end

      example_group "NOT called callback `chain.yield`" do
        context "when first around callback does NOT call callback `chain.yield`" do
          before do
            service_class.around(:result) do |chain|
              out.puts "first around before result"

              out.puts "first around after result"
            end

            service_class.around(:result) do |chain|
              out.puts "second around before result"

              chain.yield

              out.puts "second around after result"
            end
          end

          let(:error_message) do
            <<~TEXT
              Around callback chain is NOT continued from `#{service_instance.callbacks.for([:around, :result]).first.block.source_location}`.

              Did you forget to call `chain.yield`? For example:

              around :result do |chain|
                # ...
                chain.yield
                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued`" do
            expect { method_value }
              .to raise_error(ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued)
              .with_message(error_message)
          end
        end

        context "when intermediate around callback does NOT call callback `chain.yield`" do
          before do
            service_class.around(:result) do |chain|
              out.puts "first around before result"

              chain.yield

              out.puts "first around after result"
            end

            service_class.around(:result) do |chain|
              out.puts "second around before result"

              out.puts "second around after result"
            end

            service_class.around(:result) do |chain|
              out.puts "trird around before result"

              chain.yield

              out.puts "trird around after result"
            end
          end

          let(:error_message) do
            <<~TEXT
              Around callback chain is NOT continued from `#{service_instance.callbacks.for([:around, :result])[1].block.source_location}`.

              Did you forget to call `chain.yield`? For example:

              around :result do |chain|
                # ...
                chain.yield
                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued`" do
            expect { method_value }
              .to raise_error(ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued)
              .with_message(error_message)
          end
        end

        context "when last around callback does NOT call callback `chain.yield`" do
          before do
            service_class.around(:result) do |chain|
              out.puts "first around before result"

              chain.yield

              out.puts "first around after result"
            end

            service_class.around(:result) do |chain|
              out.puts "second around before result"

              out.puts "second around after result"
            end
          end

          let(:error_message) do
            <<~TEXT
              Around callback chain is NOT continued from `#{service_instance.callbacks.for([:around, :result]).last.block.source_location}`.

              Did you forget to call `chain.yield`? For example:

              around :result do |chain|
                # ...
                chain.yield
                # ...
              end
            TEXT
          end

          it "raises `ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued`" do
            expect { method_value }
              .to raise_error(ConvenientService::Common::Plugins::HasAroundCallbacks::Errors::AroundCallbackChainIsNotContinued)
              .with_message(error_message)
          end
        end
      end

      example_group "context" do
        let(:service_class) do
          Class.new do
            include ConvenientService::Common::Plugins::HasCallbacks::Concern
            include ConvenientService::Common::Plugins::HasAroundCallbacks::Concern

            def some_instance_method
            end

            def result
            end
          end
        end

        example_group "around callbacks context" do
          before do
            service_class.around(:result) do |chain|
              some_instance_method

              chain.yield
            end
          end

          it "executes around callbacks in instance context" do
            expect { method_value }.not_to raise_error
          end
        end
      end

      example_group "method arguments" do
        subject(:method_value) { method.call(*args, **kwargs, &block) }

        let(:args) { [:foo] }
        let(:kwargs) { {foo: :bar} }
        let(:block) { proc { :foo } }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(result_original_value, out) do |result_original_value, out|
              include ConvenientService::Common::Plugins::HasCallbacks::Concern
              include ConvenientService::Common::Plugins::HasAroundCallbacks::Concern

              define_method(:result) { |*args, **kwargs, &block| result_original_value }
            end
          end
        end

        example_group "before callbacks method arguments" do
          before do
            service_class.around(:result) do |chain, arguments|
              raise if arguments.args != [:foo]
              raise if arguments.kwargs != {foo: :bar}
              raise if arguments.block.call != :foo

              chain.yield
            end
          end

          it "passes chain and args, kwargs, block as arguments object" do
            expect { method_value }.not_to raise_error
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::HasCallbacks::Middleware do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { middleware }

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
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middleware: middleware) }

      let(:out) { Tempfile.new }
      let(:output) { out.tap(&:rewind).read }
      let(:result_original_value) { "result original value" }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(result_original_value, out, middleware) do |result_original_value, out, middleware|
            include ConvenientService::Configs::Standard

            middlewares :result do
              observe middleware
            end

            define_method(:out) { out }

            define_method(:result) { success(value: result_original_value).tap { out.puts "original result" } }
          end
        end
      end

      let(:service_instance) { service_class.new }

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .and_return_its_value
      end

      context "when service class has no callbacks" do
        let(:text) do
          <<~TEXT
            original result
          TEXT
        end

        it "runs only `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has one before callback" do
        let(:text) do
          <<~TEXT
            first before result
            original result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
        end

        it "runs that before callback in addition to `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has one after callback" do
        let(:text) do
          <<~TEXT
            original result
            first after result
          TEXT
        end

        before do
          service_class.after(:result) { out.puts "first after result" }
        end

        it "runs that after callback in addition to `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has multiple before callbacks" do
        let(:text) do
          <<~TEXT
            first before result
            second before result
            original result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
          service_class.before(:result) { out.puts "second before result" }
        end

        it "runs those before callbacks in addition to `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has multiple after callbacks" do
        let(:text) do
          <<~TEXT
            original result
            second after result
            first after result
          TEXT
        end

        before do
          service_class.after(:result) { out.puts "first after result" }
          service_class.after(:result) { out.puts "second after result" }
        end

        it "runs those after callbacks in addition to `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      context "when service class has before and after callbacks" do
        let(:text) do
          <<~TEXT
            first before result
            second before result
            original result
            second after result
            first after result
          TEXT
        end

        before do
          service_class.before(:result) { out.puts "first before result" }
          service_class.before(:result) { out.puts "second before result" }

          service_class.after(:result) { out.puts "first after result" }
          service_class.after(:result) { out.puts "second after result" }
        end

        it "runs those before and after callbacks in addition to `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      example_group "after callbacks first argument" do
        before do
          ##
          # NOTE: `result_original_value` is NOT available inside service instance context.
          # That is why "chain next value" literal is used.
          #
          service_class.after(:result) { |result| raise if result.unsafe_data[:value] != "result original value" }
        end

        it "passes `chain.next` to all after callbacks as first argument" do
          expect { method_value }.not_to raise_error
        end
      end

      example_group "context" do
        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Configs::Standard

              middlewares :result do
                observe middleware
              end

              def some_instance_method
              end

              def result
                success
              end
            end
          end
        end

        example_group "before callbacks context" do
          before do
            service_class.before(:result) { some_instance_method }
          end

          it "executes before callbacks in instance context" do
            expect { method_value }.not_to raise_error
          end
        end

        example_group "after callbacks context" do
          before do
            service_class.after(:result) { some_instance_method }
          end

          it "executes after callbacks in instance context" do
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
            klass.class_exec(result_original_value, out, middleware) do |result_original_value, out, middleware|
              include ConvenientService::Configs::Standard

              middlewares :result do
                observe middleware
              end

              define_method(:result) { |*args, **kwargs, &block| success(value: result_original_value) }
            end
          end
        end

        example_group "before callbacks method arguments" do
          before do
            service_class.before(:result) do |arguments|
              raise if arguments.args != [:foo]
              raise if arguments.kwargs != {foo: :bar}
              raise if arguments.block.call != :foo
            end
          end

          it "passes args, kwargs, block as arguments object" do
            expect { method_value }.not_to raise_error
          end
        end

        example_group "after callbacks method arguments" do
          before do
            service_class.after(:result) do |original_value, arguments|
              raise if original_value.unsafe_data[:value] != "result original value"
              raise if arguments.args != [:foo]
              raise if arguments.kwargs != {foo: :bar}
              raise if arguments.block.call != :foo
            end
          end

          it "passes original value and args, kwargs, block as arguments object" do
            expect { method_value }.not_to raise_error
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

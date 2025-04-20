# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Common::Plugins::CanHaveCallbacks::Middleware, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { middleware }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for any_method, entity: any_entity
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

      let(:method) { wrap_method(service_instance, :result, observe_middleware: middleware) }

      let(:out) { Tempfile.new }
      let(:output) { out.tap(&:rewind).read }
      let(:result_original_value) { "result original value" }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(result_original_value, out, middleware) do |result_original_value, out, middleware|
            include ConvenientService::Standard::Config

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

        it "runs only middleware `chain.next`" do
          method_value

          expect(output).to eq(text)
        end
      end

      example_group "before/after callbacks" do
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

          ##
          # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
          #
          it "passes original value to all after callbacks as first argument" do
            expect { method_value }.not_to raise_error
          end
        end

        example_group "context" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Standard::Config

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

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
            it "executes before callbacks in instance context" do
              expect { method_value }.not_to raise_error
            end
          end

          example_group "after callbacks context" do
            before do
              service_class.after(:result) { some_instance_method }
            end

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
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
                include ConvenientService::Standard::Config

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

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
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

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
            it "passes original value and args, kwargs, block as arguments object" do
              expect { method_value }.not_to raise_error
            end
          end
        end
      end

      example_group "around callbacks" do
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

        example_group "around callbacks first argument" do
          before do
            service_class.around(:result) { |chain| raise if chain.yield.unsafe_data[:value] != "result original value" }
          end

          ##
          # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
          #
          it "passes middleware `chain.next` to all around callbacks as first argument" do
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
              raise if result.unsafe_data[:value] != "result original value"

              out.puts "first around after result"
            end

            service_class.around(:result) do |chain|
              out.puts "second around before result"

              result = chain.yield

              ##
              # NOTE: `result_original_value` is NOT available inside service instance context.
              # That is why "result original value" literal is used.
              #
              raise if result.unsafe_data[:value] != "result original value"

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

            let(:exception_message) do
              <<~TEXT
                Around callback chain is NOT continued from `#{service_class.callbacks.for([:around, :result]).first.source_location_joined_by_colon}`.

                Did you forget to call `chain.yield`? For example:

                around :result do |chain|
                  # ...
                  chain.yield
                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued`" do
              expect { method_value }
                .to raise_error(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued) { method_value } }
                .to delegate_to(ConvenientService, :raise)
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

            let(:exception_message) do
              <<~TEXT
                Around callback chain is NOT continued from `#{service_class.callbacks.for([:around, :result])[1].source_location_joined_by_colon}`.

                Did you forget to call `chain.yield`? For example:

                around :result do |chain|
                  # ...
                  chain.yield
                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued`" do
              expect { method_value }
                .to raise_error(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued) { method_value } }
                .to delegate_to(ConvenientService, :raise)
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

            let(:exception_message) do
              <<~TEXT
                Around callback chain is NOT continued from `#{service_class.callbacks.for([:around, :result]).last.source_location_joined_by_colon}`.

                Did you forget to call `chain.yield`? For example:

                around :result do |chain|
                  # ...
                  chain.yield
                  # ...
                end
              TEXT
            end

            it "raises `ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued`" do
              expect { method_value }
                .to raise_error(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued)
                .with_message(exception_message)
            end

            specify do
              expect { ignoring_exception(ConvenientService::Common::Plugins::CanHaveCallbacks::Exceptions::AroundCallbackChainIsNotContinued) { method_value } }
                .to delegate_to(ConvenientService, :raise)
            end
          end
        end

        example_group "context" do
          let(:service_class) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Standard::Config

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

          example_group "around callbacks context" do
            before do
              service_class.around(:result) do |chain|
                some_instance_method

                chain.yield
              end
            end

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
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
              klass.class_exec(result_original_value, out, middleware) do |result_original_value, out, middleware|
                include ConvenientService::Standard::Config

                middlewares :result do
                  observe middleware
                end

                define_method(:result) { |*args, **kwargs, &block| success(value: result_original_value) }
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

            ##
            # TODO: Use `expect(output).to eq(text)`. Otherwise this spec may become false-positive after not careful source changes.
            #
            it "passes chain and args, kwargs, block as arguments object" do
              expect { method_value }.not_to raise_error
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

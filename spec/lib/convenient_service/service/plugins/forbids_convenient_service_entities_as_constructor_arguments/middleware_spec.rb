# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware, type: :standard do
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
          intended_for :initialize, entity: :service
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

      subject(:method_value) { method.call(*args, **kwargs, &block) }

      let(:method) { wrap_method(service_instance, :initialize, observe_middleware: middleware) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Standard::Config

            middlewares :initialize do
              use_and_observe middleware
            end
          end
        end
      end

      let(:service_instance) { service_class.allocate }

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .with_arguments(*args, **kwargs, &block)
          .and_return_its_value
      end

      example_group "comprehensive suite" do
        let(:config) do
          Module.new do
            include ConvenientService::Support::Concern

            included do
              include ConvenientService::Standard::Config

              middlewares :initialize do
                use ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware
              end
            end
          end
        end

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(config) do |config|
              include config

              def result
                success
              end
            end
          end
        end

        let(:service) { service_class.new }

        let(:other_service_class) do
          Class.new do
            include ConvenientService::Standard::Config

            step :result

            def result
              success
            end
          end
        end

        let(:other_service) { other_service_class.new }

        let(:result) { other_service_class.result }
        let(:step) { other_service_class.new.steps.first }

        context "when NO arguments passed to service constructor" do
          let(:service) { service_class.new }

          it "does NOT raise" do
            expect { service }.not_to raise_error
          end
        end

        context "when args are passed to service constructor" do
          context "when none of those args are Convenient Service entities" do
            let(:service) { service_class.new(:foo, :bar) }

            it "does NOT raise" do
              expect { service }.not_to raise_error
            end
          end

          context "when one of those args is Convenient Service entity" do
            context "when one of those args is service" do
              let(:service) { service_class.new(:foo, other_service) }

              let(:exception_message) do
                <<~TEXT
                  Other service `#{ConvenientService::Utils::Class.display_name(other_service.class)}` is passed as constructor argument `args[1]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end

            context "when one of those args is result" do
              let(:service) { service_class.new(:foo, result) }

              let(:exception_message) do
                <<~TEXT
                  Result of `#{ConvenientService::Utils::Class.display_name(result.service.class)}` is passed as constructor argument `args[1]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end

            context "when one of those args is step" do
              let(:service) { service_class.new(:foo, step) }

              let(:exception_message) do
                <<~TEXT
                  Step of `#{ConvenientService::Utils::Class.display_name(step.organizer.class)}` is passed as constructor argument `args[1]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end
          end

          context "when multiple of those args are Convenient Service entities" do
            let(:service) { service_class.new(:foo, other_service, step) }

            let(:exception_message) do
              <<~TEXT
                Other service `#{ConvenientService::Utils::Class.display_name(other_service_class)}` is passed as constructor argument `args[1]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
              TEXT
            end

            it "prioritizes exception for first arg of them" do
              expect { service }
                .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument)
                .with_message(exception_message)
            end
          end
        end

        context "when kwargs are passed to service constructor" do
          context "when none of those kwargs are Convenient Service entities" do
            it "does NOT raise" do
              expect { service }.not_to raise_error
            end
          end

          context "when one of those kwargs is Convenient Service entity" do
            context "when one of those kwargs is service" do
              let(:service) { service_class.new(foo: :bar, baz: other_service) }

              let(:exception_message) do
                <<~TEXT
                  Other service `#{ConvenientService::Utils::Class.display_name(other_service_class)}` is passed as constructor argument `kwargs[:baz]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end

            context "when one of those kwargs is result" do
              let(:service) { service_class.new(foo: :bar, baz: result) }

              let(:exception_message) do
                <<~TEXT
                  Result of `#{ConvenientService::Utils::Class.display_name(result.service.class)}` is passed as constructor argument `kwargs[:baz]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ResultPassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end

            context "when one of those kwargs is step" do
              let(:service) { service_class.new(foo: :bar, baz: step) }

              let(:exception_message) do
                <<~TEXT
                  Step of `#{step.printable_container}` is passed as constructor argument `kwargs[:baz]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                  It is an antipattern. It neglects the idea of steps.

                  Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
                TEXT
              end

              it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument`" do
                expect { service }
                  .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument)
                  .with_message(exception_message)
              end
            end
          end

          context "when multiple of those kwargs are Convenient Service entities" do
            let(:service) { service_class.new(foo: :bar, baz: other_service, qux: result) }

            let(:exception_message) do
              <<~TEXT
                Other service `#{ConvenientService::Utils::Class.display_name(other_service_class)}` is passed as constructor argument `kwargs[:baz]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
              TEXT
            end

            it "prioritizes exception for first kwargs of them" do
              expect { service }
                .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument)
                .with_message(exception_message)
            end
          end
        end

        context "when args and kwargs are passed to service constructor" do
          context "when some of those args and kwargs are Convenient Service entities" do
            let(:service) { service_class.new(:foo, other_service, bar: :baz, qux: result) }

            let(:exception_message) do
              <<~TEXT
                Other service `#{ConvenientService::Utils::Class.display_name(other_service_class)}` is passed as constructor argument `args[1]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

                It is an antipattern. It neglects the idea of steps.

                Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
              TEXT
            end

            it "prioritizes exception for arg" do
              expect { service }
                .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::ServicePassedAsConstructorArgument)
                .with_message(exception_message)
            end
          end
        end

        context "when step with no organizer is passed" do
          let(:service) { service_class.new(step) }
          let(:step) { other_service_class.steps.first }

          let(:exception_message) do
            <<~TEXT
              Step of `#{step.printable_container}` is passed as constructor argument `args[0]` to `#{ConvenientService::Utils::Class.display_name(service_class)}`.

              It is an antipattern. It neglects the idea of steps.

              Please, try to reorganize `#{ConvenientService::Utils::Class.display_name(service_class)}` service.
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument`" do
            expect { service }
              .to raise_error(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions::StepPassedAsConstructorArgument)
              .with_message(exception_message)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::CanBeExecuted::Middleware do
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
          intended_for :service_result, entity: :step
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
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :service_result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step is NOT `:result` step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, middleware) do |first_step, middleware|
              include ConvenientService::Configs::Minimal

              self::Step.class_exec(middleware) do |middleware|
                middlewares :service_result do
                  observe middleware
                end
              end

              step first_step
            end
          end
        end

        let(:first_step) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              success
            end
          end
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .without_arguments
            .and_return_its_value
        end
      end

      context "when step is `:result` step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Configs::Minimal

              self::Step.class_exec(middleware) do |middleware|
                middlewares :service_result do
                  observe middleware
                end
              end

              step :result

              def result
                success
              end
            end
          end
        end

        specify do
          expect { method_value }.not_to call_chain_next.on(method)
        end

        context "when `organizer` does NOT have own `:result` method" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(middleware) do |middleware|
                include ConvenientService::Configs::Minimal

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :service_result do
                    observe middleware
                  end
                end

                step :result
              end
            end
          end

          let(:error_message) do
            <<~TEXT
              Service `#{container}` tries to use `:result` method in a step, but it is NOT defined.

              Did you forget to define it?
            TEXT
          end

          it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined`" do
            expect { method_value }
              .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeResultStep::CanBeExecuted::Exceptions::MethodForStepIsNotDefined)
              .with_message(error_message)
          end
        end

        context "when `organizer` has own `:result` method" do
          let(:container) do
            Class.new.tap do |klass|
              klass.class_exec(prepend_module, middleware) do |prepend_module, middleware|
                include ConvenientService::Configs::Minimal

                self::Step.class_exec(middleware) do |middleware|
                  middlewares :service_result do
                    observe middleware
                  end
                end

                step :result

                def result
                  success
                end

                ##
                # NOTE: Used to confirm that own is called, not prepended method.
                #
                prepend prepend_module
              end
            end
          end

          let(:prepend_module) do
            Module.new.tap do |mod|
              def result
                failure
              end
            end
          end

          it "calls that own method" do
            ##
            # NOTE: Own method returns `success`, while prepended returns `failure`.
            # See `organizer_service_class` definition above.
            #
            expect(method_value).to be_success
          end

          specify do
            expect { method_value }
              .to delegate_to(ConvenientService::Utils::Module, :get_own_instance_method)
              .with_arguments(step.organizer.class, step.method, private: true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

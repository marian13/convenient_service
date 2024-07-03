# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Middleware, type: :standard do
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
          intended_for any_method, entity: :step
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
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step `result` is NOT result" do
        include ConvenientService::RSpec::Helpers::IgnoringException

        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Service::Configs::Essential
              include ConvenientService::Service::Configs::Inspect
              self::Step.class_exec(middleware) do |middleware|
                middlewares :result do
                  observe middleware
                end
              end

              step :foo

              def foo
                "foo"
              end
            end
          end
        end

        let(:exception_message) do
          <<~TEXT
            Return value of step `#{step.printable_action}` is NOT a `Result`.
            It is `String`.

            Did you forget to call `success`, `failure`, or `error`?
          TEXT
        end

        ##
        # NOTE: Error is NOT the purpose of this spec. That is why it is caught.
        # But if it is NOT caught, the spec should fail.
        #
        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult) { method_value } }
            .to call_chain_next.on(method)
        end

        it "raises `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult`" do
          expect { method_value }
            .to raise_error(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::RaisesOnNotResultReturnValue::Exceptions::ReturnValueNotKindOfResult) { method_value } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when step `result` is result" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Service::Configs::Essential
              include ConvenientService::Service::Configs::Inspect
              self::Step.class_exec(middleware) do |middleware|
                middlewares :result do
                  observe middleware
                end
              end

              step :foo

              def foo
                success
              end
            end
          end
        end

        specify do
          expect { method_value }.to call_chain_next.on(method)
        end

        it "returns original method value" do
          expect(method_value).to be_success.without_data
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

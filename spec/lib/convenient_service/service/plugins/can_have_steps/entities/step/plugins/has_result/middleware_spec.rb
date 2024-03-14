# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasResult::Middleware do
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
          intended_for :result, entity: :step
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
      include ConvenientService::RSpec::Matchers::Results

      subject(:method_value) { method.call }

      let(:method) { wrap_method(step, :result, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(first_step, middleware) do |first_step, middleware|
            include ConvenientService::Service::Configs::Essential

            self::Step.class_exec(middleware) do |middleware|
              middlewares :result do
                observe middleware
              end
            end

            step first_step
          end
        end
      end

      let(:first_step) do
        Class.new do
          include ConvenientService::Service::Configs::Essential

          def result
            success(data: {foo: :bar})
          end
        end
      end

      specify do
        expect { method_value }
          .to call_chain_next.on(method)
          .without_arguments
      end

      it "returns service result with step and organizer" do
        expect(step.result).to be_success.with_data(foo: :bar).of_step(first_step).of_service(container)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeTried::Initialize::Middleware do
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
          intended_for :initialize, entity: :step
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

      subject(:method_value) { method.call(*step.to_args, **step.to_kwargs) }

      let(:method) { wrap_method(step, :initialize, observe_middleware: middleware) }

      let(:step_service_class) do
        Class.new do
          include ConvenientService::Configs::Standard
        end
      end

      let(:organizer_service_class) do
        Class.new.tap do |klass|
          klass.class_exec(step_service_class, middleware) do |step_service_class, middleware|
            include ConvenientService::Configs::Standard

            self::Step.class_exec(middleware) do |middleware|
              middlewares :initialize do
                observe middleware
              end
            end

            step step_service_class, try: true
          end
        end
      end

      let(:organizer_service_instance) { organizer_service_class.new }

      let(:step) { organizer_service_instance.steps.first }

      specify do
        expect { method_value }.to call_chain_next.on(method).with_arguments(*step.to_args, **step.to_kwargs)
      end

      specify do
        expect { method_value }
          .to delegate_to(step.internals.cache, :write)
          .with_arguments(:try, true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

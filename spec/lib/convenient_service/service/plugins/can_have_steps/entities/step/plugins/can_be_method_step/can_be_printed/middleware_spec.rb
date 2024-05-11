# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::CanBePrinted::Middleware, type: :standard do
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
          intended_for :printable_service, entity: :step
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

      let(:method) { wrap_method(step, :printable_service, observe_middleware: middleware) }

      let(:organizer) { container.new }
      let(:step) { organizer.steps.first }

      context "when step is NOT method step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(first_step, middleware) do |first_step, middleware|
              include ConvenientService::Service::Configs::Essential

              self::Step.class_exec(middleware) do |middleware|
                middlewares :printable_service do
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

      context "when step is method step" do
        let(:container) do
          Class.new.tap do |klass|
            klass.class_exec(middleware) do |middleware|
              include ConvenientService::Service::Configs::Essential

              self::Step.class_exec(middleware) do |middleware|
                middlewares :printable_service do
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
          expect { method_value }.not_to call_chain_next.on(method)
        end

        it "returns method step printable represantation" do
          expect(method_value).to eq(":#{step.method}")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

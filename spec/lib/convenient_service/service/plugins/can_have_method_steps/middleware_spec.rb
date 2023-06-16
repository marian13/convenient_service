# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CanHaveMethodSteps::Middleware do
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
          intended_for :step, scope: :class, entity: :service
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

      subject(:method_value) { method.call(service, **kwargs) }

      let(:method) { wrap_method(container, :step, observe_middleware: middleware) }

      let(:container) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Minimal

            middlewares :step, scope: :class do
              observe middleware
            end
          end
        end
      end

      let(:kwargs) { {in: :foo, out: :bar, index: 0} }

      context "when step service is NOT symbol" do
        let(:service) { Class.new }

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(service, **kwargs)
        end

        it "returns original step" do
          method_value

          expect(container.steps.first).to eq(container.step(service, **kwargs))
        end
      end

      context "when step service is symbol" do
        let(:service) { method_name }
        let(:method_name) { :foo }

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(container, **kwargs.merge(method: method_name))
        end

        it "returns customized step" do
          method_value

          expect(container.steps.first).to eq(container.step(container, **kwargs.merge(method: method_name)))
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::CountsResultResolutionsInvocations::Middleware, type: :standard do
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
          intended_for [:success, :failure, :error], entity: :service
        end
      end

      it "returns intended methods" do
        expect(middleware.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  shared_examples "verify middleware behavior" do
    example_group "instance methods" do
      describe "#call" do
        include ConvenientService::RSpec::Helpers::WrapMethod

        include ConvenientService::RSpec::Matchers::CallChainNext

        subject(:method_value) { method.call }

        let(:method) { wrap_method(service_instance, method_name, observe_middleware: middleware) }

        let(:kwargs) { {data: {foo: :bar}, message: "foo", code: :foo} }

        let(:service_class) do
          Class.new.tap do |klass|
            klass.class_exec(method_name, middleware) do |method_name, middleware|
              include ConvenientService::Standard::Config
              include ConvenientService::CodeReviewAutomation::Config

              middlewares method_name do
                observe middleware
              end
            end
          end
        end

        let(:service_instance) { service_class.new }

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**kwargs)
            .and_return_its_value
        end

        specify do
          expect { method_value }
            .to delegate_to(service_instance.result_resolutions_counter, :increment!)
            .without_arguments
        end
      end
    end
  end

  context "when `method_name` is `:success`" do
    include_examples "verify middleware behavior" do
      let(:method_name) { :success }
    end
  end

  context "when `method_name` is `:failure`" do
    include_examples "verify middleware behavior" do
      let(:method_name) { :failure }
    end
  end

  context "when `method_name` is `:error`" do
    include_examples "verify middleware behavior" do
      let(:method_name) { :error }
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

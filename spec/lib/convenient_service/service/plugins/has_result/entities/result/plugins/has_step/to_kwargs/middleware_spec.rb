# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::ToKwargs::Middleware do
  let(:middleware) { described_class }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :to_kwargs, entity: :result
        end
      end

      it "returns intended methods" do
        expect(described_class.intended_methods).to eq(spec.intended_methods)
      end
    end
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext

      subject(:method_value) { method.call }

      let(:method) { wrap_method(result, :to_kwargs, observe_middleware: middleware) }

      let(:service) do
        Class.new.tap do |klass|
          klass.class_exec(middleware) do |middleware|
            include ConvenientService::Configs::Standard

            self::Result.class_exec(middleware) do |middleware|
              middlewares :to_kwargs do
                observe middleware
              end
            end

            def result
              success
            end
          end
        end
      end

      let(:result) { service.result }

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end

      it "merges step to kwargs" do
        expect(method_value[:step]).to eq(result.step)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

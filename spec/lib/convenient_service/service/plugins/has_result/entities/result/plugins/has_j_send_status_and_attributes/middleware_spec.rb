# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
  end

  example_group "class methods" do
    describe ".intended_methods" do
      let(:spec) do
        Class.new(ConvenientService::MethodChainMiddleware) do
          intended_for :initialize
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
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:method_value) { method.call(**kwargs) }

      let(:method) { wrap_method(result, :initialize, middlewares: described_class) }

      let(:kwargs) do
        {
          service: double,
          status: :foo,
          data: {foo: :bar},
          message: "foo",
          code: :foo
        }
      end

      let(:service) do
        Class.new do
          include ConvenientService::Configs::Minimal

          def result
            success
          end
        end
      end

      let(:result) { service.result }

      specify do
        expect { method_value }
          .to delegate_to(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Commands::CastJSendAttributes, :call)
          .with_arguments(result: result, kwargs: kwargs)
      end

      specify do
        expect { method_value }.to call_chain_next.on(method)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

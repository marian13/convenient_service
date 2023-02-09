# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::Initialize::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod
      include ConvenientService::RSpec::Matchers::CallChainNext
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:method_value) { method.call(**attributes) }

      ##
      # TODO: Factory for result without middlewares.
      #
      let(:method) { wrap_method(result, :initialize, middlewares: described_class) }

      let(:result) { ConvenientService::Factory.create(:result) }

      context "when `step` is NOT passed" do
        let(:attributes) { ConvenientService::Factory.create(:result_attributes) }

        specify do
          expect { method_value }
            .to delegate_to(result.internals.cache, :write)
            .with_arguments(:step, nil)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**attributes)
            .and_return_its_value
        end
      end

      context "when `step` is passed" do
        let(:attributes) { ConvenientService::Factory.create(:result_attributes_with_step, step: step) }
        let(:step) { ConvenientService::Factory.create(:step_instance) }

        specify do
          expect { method_value }
            .to delegate_to(result.internals.cache, :write)
            .with_arguments(:step, step)
        end

        specify do
          expect { method_value }
            .to call_chain_next.on(method)
            .with_arguments(**attributes)
            .and_return_its_value
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasStep::Initialize::Middleware do
  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::MethodChainMiddleware) }
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

      let(:result) { service.result }

      context "when `step` is NOT passed" do
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Minimal

            def result
              success
            end
          end
        end

        let(:attributes) { result.jsend_attributes.to_h }

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
        let(:service) do
          Class.new do
            include ConvenientService::Configs::Minimal

            step :result

            def result
              success
            end
          end
        end

        let(:attributes) { result.jsend_attributes.to_h.merge(step: step) }
        let(:step) { service.steps.first }

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

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasResultSteps::Middleware do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Core::MethodChainMiddleware) }
  end

  example_group "instance methods" do
    describe "#call" do
      include ConvenientService::RSpec::Helpers::WrapMethod

      subject(:method_value) { method.call }

      let(:method) { wrap_method(service_instance, :result, middlewares: described_class) }
      let(:service_instance) { service_class.new }

      context "when service has no steps" do
        let(:service_class) { ConvenientService::Factory.create(:service_with_success_result) }

        it "calls super" do
          ##
          # NOTE: Should return success, see how result is defined above.
          #
          expect(method_value).to be_success
        end
      end

      context "when intermediate step is NOT successful" do
        let(:first_step) { ConvenientService::Factory.create(:service_with_not_success_result) }
        let(:second_step) { ConvenientService::Factory.create(:service_with_success_result) }

        let(:service_class) { ConvenientService::Factory.create(:service, steps: [first_step, second_step]) }

        it "returns result of intermediate step" do
          expect(method_value).to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:completed?).result)
        end

        it "copies result of intermediate step" do
          expect(method_value.object_id).not_to eq(ConvenientService::Utils::Array.find_last(service_instance.steps, &:completed?).result.object_id)
        end

        it "does NOT evaluate results of following steps" do
          allow(second_step).to receive(:new).and_call_original

          method_value

          expect(second_step).not_to have_received(:new)
        end

        it "calls `step` method for NOT successful intermediate step" do
          expect { method_value }
            .to delegate_to(service_instance, :step)
            .with_arguments(0)
        end

        it "does NOT call step for following steps" do
          expect { method_value }
            .not_to delegate_to(service_instance, :step)
            .with_arguments(1)
        end

        it "calls `step` method for intermediate step after checking status" do
          method_value

          expect { service_instance.steps[0].data }.not_to raise_error(ConvenientService::Error)
        end

        it "does NOT call `step` method for last step after checking status" do
          method_value

          expect { service_instance.steps[1].data }.to raise_error(ConvenientService::Error)
        end
      end

      context "when all steps are successful" do
        let(:first_step) { ConvenientService::Factory.create(:service_with_success_result) }
        let(:second_step) { ConvenientService::Factory.create(:service_with_success_result) }

        let(:service_class) { ConvenientService::Factory.create(:service, steps: [first_step, second_step]) }

        it "returns result of last step" do
          expect(method_value).to eq(service_instance.steps.last.result)
        end

        it "copies result of last step" do
          expect(method_value.object_id).not_to eq(service_instance.steps.last.result.object_id)
        end

        it "calls `step` method for intermediate step" do
          expect { method_value }
            .to delegate_to(service_instance, :step)
            .with_arguments(0)
        end

        it "calls `step` method for last step" do
          expect { method_value }
            .to delegate_to(service_instance, :step)
            .with_arguments(1)
        end

        it "calls `step` method for intermediate step after checking status" do
          method_value

          expect { service_instance.steps[0].data }.not_to raise_error(ConvenientService::Error)
        end

        it "calls `step` method for last step after checking status" do
          method_value

          expect { service_instance.steps[1].data }.not_to raise_error(ConvenientService::Error)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

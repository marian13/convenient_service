# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::Inspect, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Service::Plugins::HasInspect::Concern` from service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasInspect::Concern)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern` from service concerns" do
              expect(service_class::Result.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasInspect::Concern)
            end
          end

          example_group "service result data" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Data.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern)
              end
            end
          end

          example_group "service result message" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Message.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern)
              end
            end
          end

          example_group "service result code" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Code.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins::HasInspect::Concern)
              end
            end
          end

          example_group "service result status" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Status.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern)
              end
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern` from service concerns" do
              expect(service_class::Step.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

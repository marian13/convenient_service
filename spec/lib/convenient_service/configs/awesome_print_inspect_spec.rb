# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Configs::AwesomePrintInspect do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Configs::Minimal) }

      ##
      # TODO: Complete.
      #
      example_group "service" do
        example_group "concerns" do
          it "removes `ConvenientService::Service::Plugins::HasInspect::Concern` from service concerns" do
            expect(service_class.concerns.to_a).not_to include(ConvenientService::Service::Plugins::HasInspect::Concern)
          end

          it "adds `ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Service::Plugins::HasAwesomePrintInspect::Concern)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "removes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern` from service concerns" do
              expect(service_class::Result.concerns.to_a).not_to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasInspect::Concern)
            end

            it "adds `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
              expect(service_class::Result.concerns.to_a).to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasAwesomePrintInspect::Concern)
            end
          end

          example_group "service result data" do
            example_group "concerns" do
              it "removes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Data.concerns.to_a).not_to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasInspect::Concern)
              end

              it "adds `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Data.concerns.to_a).to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data::Plugins::HasAwesomePrintInspect::Concern)
              end
            end
          end

          example_group "service result message" do
            example_group "concerns" do
              it "removes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Message.concerns.to_a).not_to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasInspect::Concern)
              end

              it "adds `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Message.concerns.to_a).to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins::HasAwesomePrintInspect::Concern)
              end
            end
          end

          # example_group "service result code" do
          #   example_group "concerns" do
          #     it "removes `HasInspect::Concern` from service concerns" do
          #       expect(service_class.::Result::Code.concerns.to_a).not_to include(HasInspect::Concern)
          #     end
          #
          #     it "adds `HasAwesomeInspect::Concern` from service concerns" do
          #       expect(service_class.::Result::Code.concerns.to_a).to include(HasAwesomeInspect::Concern)
          #     end
          #   end
          # end

          example_group "service result status" do
            example_group "concerns" do
              it "removes `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern` from service concerns" do
                expect(service_class::Result::Status.concerns.to_a).not_to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasInspect::Concern)
              end

              it "adds `ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
                expect(service_class::Result::Status.concerns.to_a).to include(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::HasAwesomePrintInspect::Concern)
              end
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "removes `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern` from service concerns" do
              expect(service_class::Step.concerns.to_a).not_to include(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasInspect::Concern)
            end

            it "adds `ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern` from service concerns" do
              expect(service_class::Step.concerns.to_a).to include(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::HasAwesomePrintInspect::Concern)
            end
          end
        end
      end
    end

    context "when included multiple times" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod

            include mod
          end
        end
      end

      ##
      # NOTE: Check the following discussion for details:
      # https://github.com/marian13/convenient_service/discussions/43
      #
      it "applies its `included` block only once" do
        expect(service_class.concerns.to_a.size).to eq(6)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

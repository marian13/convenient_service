# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::CodeReviewAutomation, type: :standard do
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

      specify { expect(service_class).to include_module(ConvenientService::Core) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Service::Plugins::CanNotBeInherited::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::CanNotBeInherited::Concern)
          end
        end

        example_group "#initialize middlewares" do
          it "adds `ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware` to service middlewares for `#initialize`" do
            expect(service_class.middlewares(:initialize).to_a.last).to eq(ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Middleware)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Concern` to service result concerns" do
              expect(service_class::Result.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Concern)
            end
          end

          example_group "#data middlewares" do
            let(:data_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#data`" do
              expect(service_class::Result.middlewares(:data).to_a).to eq(data_middlewares)
            end
          end

          example_group "#message middlewares" do
            let(:message_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#message`" do
              expect(service_class::Result.middlewares(:message).to_a).to eq(message_middlewares)
            end
          end

          example_group "#code middlewares" do
            let(:code_middlewares) do
              [
                ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Middleware
              ]
            end

            it "sets service result middlewares for `#code`" do
              expect(service_class::Result.middlewares(:code).to_a).to eq(code_middlewares)
            end
          end

          example_group "service result status" do
            example_group "concerns" do
              it "adds `ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Concern` to service result status concerns" do
                expect(service_class::Result::Status.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Concern)
              end
            end

            example_group "#success? middlewares" do
              let(:is_success_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#success?`" do
                expect(service_class::Result::Status.middlewares(:success?).to_a).to eq(is_success_middlewares)
              end
            end

            example_group "#failure? middlewares" do
              let(:is_failure_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#failure?`" do
                expect(service_class::Result::Status.middlewares(:failure?).to_a).to eq(is_failure_middlewares)
              end
            end

            example_group "#error? middlewares" do
              let(:is_error_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#error?`" do
                expect(service_class::Result::Status.middlewares(:error?).to_a).to eq(is_error_middlewares)
              end
            end

            example_group "#not_success? middlewares" do
              let(:is_not_success_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_success?`" do
                expect(service_class::Result::Status.middlewares(:not_success?).to_a).to eq(is_not_success_middlewares)
              end
            end

            example_group "#not_failure? middlewares" do
              let(:is_not_failure_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_failure?`" do
                expect(service_class::Result::Status.middlewares(:not_failure?).to_a).to eq(is_not_failure_middlewares)
              end
            end

            example_group "#not_error? middlewares" do
              let(:is_not_error_middlewares) do
                [
                  ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins::CanBeChecked::Middleware
                ]
              end

              it "sets service result status middlewares for `#not_error?`" do
                expect(service_class::Result::Status.middlewares(:not_error?).to_a).to eq(is_not_error_middlewares)
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

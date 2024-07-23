# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Configs::ShortSyntax, type: :standard do
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

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Essential) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern` to service concerns" do
            expect(service_class.concerns.to_a[-2]).to eq(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Concern)
          end

          it "adds `ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResultStatusCheckShortSyntax::Concern)
          end
        end

        example_group "#success middlewares" do
          it "adds `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Middleware` to service `#success` middlewares" do
            expect(service_class.middlewares(:success).to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Middleware)
          end
        end

        example_group "#failure middlewares" do
          it "adds `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Middleware` to service `#failure` middlewares" do
            expect(service_class.middlewares(:failure).to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Middleware)
          end
        end

        example_group "#error middlewares" do
          it "adds `ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware` to service `#error` middlewares" do
            expect(service_class.middlewares(:error).to_a.last).to eq(ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Middleware)
          end
        end

        example_group "service result" do
          example_group "concerns" do
            it "adds `ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern` to service result concerns" do
              expect(service_class::Result.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern)
            end
          end
        end

        example_group "service step" do
          example_group "concerns" do
            it "adds `ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern` to service step concerns" do
              expect(service_class::Step.concerns.to_a.last).to eq(ConvenientService::Common::Plugins::HasJSendResultDuckShortSyntax::Concern)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

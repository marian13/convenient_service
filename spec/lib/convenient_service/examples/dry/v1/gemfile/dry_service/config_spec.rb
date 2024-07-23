# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Dry::V1::Gemfile::DryService::Config, type: :dry do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    specify { expect(described_class).to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Standard::V1) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern` to service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingDryInitializer::Concern)
          end

          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern` to service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern)
          end
        end

        example_group "#result middlewares" do
          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware.with(status: :failure)` before `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` to service #result middlewares" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware.with(status: :failure) || current_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware }).not_to be_nil
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

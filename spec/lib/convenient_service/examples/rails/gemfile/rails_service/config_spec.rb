# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Rails::Gemfile::RailsService::Config, type: :rails do
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

      specify { expect(service_class).to include_module(ConvenientService::Service::Configs::Standard) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern` to service concerns" do
            expect(service_class.concerns.to_a[-3]).to eq(ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern)
          end

          it "adds `ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern` to service concerns" do
            expect(service_class.concerns.to_a[-2]).to eq(ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern)
          end

          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern)
          end
        end

        example_group "#initialize middlewares" do
          it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware` to service #initialize middlewares" do
            expect(service_class.middlewares(:initialize).to_a.last).to eq(ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware)
          end
        end

        example_group "#result middlewares" do
          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware` before `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` to service #result middlewares" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingActiveModelValidations::Middleware || current_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware }).not_to be_nil
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

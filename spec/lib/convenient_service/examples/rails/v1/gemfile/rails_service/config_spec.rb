# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Rails::V1::Gemfile::RailsService::Config, type: :rails do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::IncludeConfig

    subject { described_class }

    specify { expect(described_class).to include_module(ConvenientService::Config) }

    context "when included" do
      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      specify { expect(service_class).to include_config(ConvenientService::Standard::V1::Config.with(:active_model_validations)) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern` to service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern)
          end

          it "adds `ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern` to service concerns" do
            expect(service_class.concerns.to_a).to include(ConvenientService::Plugins::Common::HasAttributes::UsingActiveModelAttributes::Concern)
          end
        end

        example_group "#initialize middlewares" do
          it "adds `ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware` to service #initialize middlewares" do
            expect(service_class.middlewares(:initialize).to_a.last).to eq(ConvenientService::Plugins::Common::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Middleware)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Dry::Gemfile::DryService::Config, type: :dry do
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

      specify { expect(service_class).to include_config(ConvenientService::Standard::Config.with(:dry_initializer)) }

      example_group "service" do
        example_group "concerns" do
          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern` to service concerns" do
            expect(service_class.concerns.to_a.last).to eq(ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Concern)
          end
        end

        example_group "#result middlewares" do
          it "adds `ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware` before `ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware` to service #result middlewares" do
            expect(service_class.middlewares(:result).to_a.each_cons(2).find { |previous_middleware, current_middleware| previous_middleware == ConvenientService::Plugins::Service::HasJSendResultParamsValidations::UsingDryValidation::Middleware && current_middleware == ConvenientService::Plugins::Service::RaisesOnNotResultReturnValue::Middleware }).not_to be_nil
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Custom::WrapMethod do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(entity, method, observe_middleware: middleware) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Configs::Standard

          middlewares :result do
            observe ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware
          end
        end
      end

      let(:service_instance) { service_class.new }

      let(:entity) { service_instance }
      let(:method) { :result }
      let(:middleware) { ConvenientService::Service::Plugins::RaisesOnNotResultReturnValue::Middleware }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::RSpec::Helpers::Custom::WrapMethod::Entities::WrappedMethod, :new)
          .with_arguments(entity: entity, method: method, observe_middleware: middleware)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

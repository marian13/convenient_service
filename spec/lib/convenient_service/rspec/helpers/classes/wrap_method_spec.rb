# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Classes::WrapMethod, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(entity, method, observe_middleware: middleware) }

      let(:service_class) do
        Class.new do
          include ConvenientService::Standard::Config

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
          .to delegate_to(described_class::Entities::WrappedMethod, :new)
          .with_arguments(entity: entity, method: method, observe_middleware: middleware)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

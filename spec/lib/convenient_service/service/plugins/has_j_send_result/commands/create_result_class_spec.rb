# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Commands::CreateResultClass, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(service_class: service_class) }

      let(:service_class) { Class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity, :call)
          .with_arguments(namespace: service_class, proto_entity: ConvenientService::Service::Plugins::HasJSendResult::Entities::Result)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

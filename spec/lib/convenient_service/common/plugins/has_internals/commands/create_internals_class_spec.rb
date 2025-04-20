# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::HasInternals::Commands::CreateInternalsClass, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(entity_class: entity_class) }

      let(:entity_class) { Class.new }

      specify do
        expect { command_result }
          .to delegate_to(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity, :call)
          .with_arguments(namespace: entity_class, proto_entity: ConvenientService::Common::Plugins::HasInternals::Entities::Internals)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

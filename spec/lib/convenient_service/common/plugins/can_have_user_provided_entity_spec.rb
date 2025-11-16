# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Common::Plugins::CanHaveUserProvidedEntity, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".find_or_create_entity" do
      let(:namespace) { Class.new }

      let(:proto_entity) do
        Class.new do
          # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
          module self::Concern
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration

          def self.name
            "ProtoEntity"
          end
        end
      end

      specify do
        expect { described_class.find_or_create_entity(namespace, proto_entity) }
          .to delegate_to(ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity, :call)
          .with_arguments(namespace: namespace, proto_entity: proto_entity)
          .and_return_its_value
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Commands::CreateEntityClass, type: :standard do
  example_group "class methods" do
    subject(:command_result) { described_class.call(config: config, name: name) }

    let(:config) { ConvenientService::Core::Entities::Config.new(klass: entity_class) }

    let(:entity_class) do
      Class.new do
        include ConvenientService::Core
      end
    end

    let(:name) { :Result }

    describe ".call" do
      it "returns sub entity class" do
        expect(command_result).to eq(entity_class::Result)
      end

      it "sets sub entity class under entity class namespace" do
        expect { command_result }.to change { entity_class.const_defined?(name, false) }.from(false).to(true)
      end

      context "when called multiple times" do
        let(:sub_entity_class) { described_class.call(config: config, name: name) }
        let(:overriden_sub_entity_class) { described_class.call(config: config, name: name) }

        ##
        # NOTE: The silenced warnings are intentional. If the command is called multiple times, it intentionally redefines the constant. Check the source for more info.
        #   /gem/lib/convenient_service/core/entities/config/commands/create_entity_class.rb:42: warning: already initialized constant #<Class:0x00007f750f8cbeb0>::Result
        #   /gem/lib/convenient_service/core/entities/config/commands/create_entity_class.rb:42: warning: previous definition of Result was here
        #
        it "overrides previous set sub entity class" do
          ConvenientService::Utils::Kernel.silence_warnings do
            expect(sub_entity_class.object_id).not_to eq(overriden_sub_entity_class.object_id)
          end
        end
      end

      example_group "sub entity class" do
        let(:sub_entity_class) { command_result }

        it "includes `ConvenientService::Core`" do
          expect(sub_entity_class).to include(ConvenientService::Core)
        end

        it "responds to `namespace` method" do
          expect(sub_entity_class).to respond_to(:namespace)
        end

        example_group "`namespace` method" do
          it "returns entity class" do
            expect(sub_entity_class.namespace).to eq(entity_class)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

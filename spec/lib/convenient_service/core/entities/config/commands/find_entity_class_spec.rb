# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Commands::FindEntityClass, type: :standard do
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
      context "when sub entity class is NOT defined under entity class namespace" do
        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end

      context "when sub entity class is defined directly under entity class namespace" do
        before do
          entity_class.entity(name) {}
        end

        it "returns that sub entity class" do
          expect(command_result).to eq(entity_class::Result)
        end
      end

      context "when sub entity class is defined under entity class namespace parent" do
        let(:parent_class) do
          Class.new do
            # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
            class self::Result
            end
            # rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
          end
        end

        let(:entity_class) do
          Class.new(parent_class) do
            include ConvenientService::Core
          end
        end

        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Core::Entities::Config::Commands::FindOrCreateEntityClass, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

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
        specify do
          expect { command_result }
            .to delegate_to(described_class, :call)
            .with_arguments(config: config, name: name)
        end

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Core::Entities::Config::Commands::CreateEntityClass, :call)
            .with_arguments(config: config, name: name)
        end

        it "returns sub entity class" do
          expect(command_result).to eq(entity_class::Result)
        end
      end

      context "when sub entity class is defined directly under entity class namespace" do
        before do
          entity_class.entity(name) {}
        end

        specify do
          expect { command_result }
            .to delegate_to(described_class, :call)
            .with_arguments(config: config, name: name)
        end

        specify do
          expect { command_result }
            .not_to delegate_to(ConvenientService::Core::Entities::Config::Commands::CreateEntityClass, :call)
        end

        it "returns sub entity class" do
          expect(command_result).to eq(entity_class::Result)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

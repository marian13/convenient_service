# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntries, type: :standard do
  example_group "class methods" do
    describe ".call" do
      include ConvenientService::RSpec::Matchers::DelegateTo

      subject(:command_result) { described_class.call(feature_class: feature_class, names: names, body: body) }

      let(:feature_class) do
        Class.new do
          include ConvenientService::Feature::Configs::Standard
        end
      end

      let(:feature_instance) { feature_class.new }

      let(:body) { proc { |*args, **kwargs, &block| [__method__, args, kwargs, block] } }

      context "when NO names are passed" do
        let(:names) { [] }

        it "returns empty array" do
          expect(command_result).to eq([])
        end

        specify do
          expect { command_result }.not_to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, :call)
        end
      end

      context "when one name is passed" do
        let(:names) { [:foo] }

        it "returns that one name wrapped by array" do
          expect(command_result).to eq([:foo])
        end

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, :call)
            .with_arguments(feature_class: feature_class, name: names.first, body: body)
        end
      end

      context "when multiple names are passed" do
        let(:names) { [:foo, :bar] }

        it "returns those multiple names" do
          expect(command_result).to eq([:foo, :bar])
        end

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, :call)
            .with_arguments(feature_class: feature_class, name: names.first, body: body)
        end

        specify do
          expect { command_result }
            .to delegate_to(ConvenientService::Feature::Plugins::CanHaveEntries::Commands::DefineEntry, :call)
            .with_arguments(feature_class: feature_class, name: names.last, body: body)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

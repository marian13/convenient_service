# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::FetchNamespace do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(importing_module: importing_module, scope: scope, prepend: prepend) }

      let(:scope) { :class }
      let(:prepend) { false }

      let(:importing_module) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import
        end
      end

      let(:container) do
        Module.new do
          include ConvenientService::Support::DependencyContainer::Export

          export :foo do
            "foo"
          end

          export :bar, scope: :class do
            "bar"
          end
        end
      end

      describe "importing module" do
        context "when `importing module` imports method" do
          before do
            importing_module.import(method, from: container, scope: scope)
          end

          let(:method) { :bar }

          it "returns valid constant" do
            expect(command_result).to eq(importing_module::ImportedIncludedClassMethods)
          end
        end

        context "when `importing module` does NOT import any method" do
          it "returns valid constant" do
            expect(command_result).to eq(importing_module::ImportedIncludedClassMethods)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

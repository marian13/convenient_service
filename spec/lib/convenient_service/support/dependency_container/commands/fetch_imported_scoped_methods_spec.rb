# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::FetchImportedScopedMethods do
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

      example_group "importing module" do
        context "when importing module is valid" do
        end

        context "when importing module is NOT valid" do
        end
      end

      example_group "scope" do
        context "when scope is valid" do
          before do
            importing_module.import(method, from: container, scope: scope)
          end

          context "when `:class` scope" do
            let(:method) { :bar }

            it "returns valid constant" do
              expect(command_result).to eq(importing_module::ImportedIncludedClassMethods)
            end
          end

          context "when `:instance` scope" do
            let(:method) { :foo }
            let(:scope) { :instance }

            it "returns valid constant" do
              expect(command_result).to eq(importing_module::ImportedIncludedInstanceMethods)
            end
          end
        end

        context "when scope is NOT valid" do
        end
      end

      example_group "prepend" do
        context "when prepend is valid" do
          context "when prepend is false" do
          end

          context "when prepend is true" do
          end
        end

        context "when prepend is NOT valid" do
        end
      end

      example_group "block" do
        context "when block is passed" do
        end

        context "when block is NOT passed" do
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

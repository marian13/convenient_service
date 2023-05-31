# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::FetchImportedScopedMethods do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(importing_module: importing_module, scope: scope, prepend: prepend, &block) }

      let(:scope) { :class }
      let(:prepend) { false }
      let(:block) { nil }

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
        context "when importing module imports method" do
          before do
            importing_module.import(method, from: container, scope: scope)
          end

          let(:method) { :bar }

          it "returns valid constant" do
            expect(command_result).to eq(importing_module::ImportedIncludedClassMethods)
          end
        end

        context "when importing module does NOT import any method" do
          it "returns nil" do
            expect(command_result).to be_nil
          end
        end
      end

      describe "scope" do
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
          before do
            importing_module.import(method, from: container, scope: :instance)
          end

          let(:method) { :foo }
          let(:scope) { nil }

          it "returns nil" do
            expect(command_result).to be_nil
          end
        end
      end

      describe "prepend" do
        context "when prepend is valid" do
          before do
            importing_module.import(method, from: container, scope: scope, prepend: prepend)
          end

          let(:method) { :foo }
          let(:scope) { :instance }

          context "when prepend is false" do
            it "returns valid constant" do
              expect(command_result).to eq(importing_module::ImportedIncludedInstanceMethods)
            end
          end

          context "when prepend is true" do
            let(:prepend) { true }

            it "returns valid constant" do
              expect(command_result).to eq(importing_module::ImportedPrependedInstanceMethods)
            end
          end
        end

        context "when prepend is NOT valid" do
          before do
            importing_module.import(method, from: container, scope: scope, prepend: true)
          end

          let(:method) { :bar }
          let(:prepend) { nil }

          it "returns nil" do
            expect(command_result).to be_nil
          end
        end
      end

      describe "block" do
        context "when block is passed" do
          let(:block) { proc { 42 } }

          it "returns `block` value" do
            expect(command_result).to eq(block.call)
          end

          it "set own const to `block` value" do
            command_result

            expect(importing_module.const_get(:ImportedIncludedClassMethods, false)).to eq(block.call)
          end
        end

        context "when block is NOT passed" do
          it "returns nil" do
            expect(command_result).to be_nil
          end

          it "does NOT set own const" do
            command_result

            expect(importing_module.constants.include?(:ImportedIncludedClassMethods)).to be_falsey
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

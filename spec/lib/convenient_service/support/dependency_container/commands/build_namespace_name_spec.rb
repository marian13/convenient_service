# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::BuildNamespaceName do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(scope: scope, prepend: prepend) }

      let(:scope) { :class }
      let(:prepend) { false }

      describe "scope" do
        context "when `scope` is valid" do
          context "when `scope` is `:class`" do
            it "returns valid namespace name" do
              expect(command_result).to eq(:ImportedIncludedClassMethods)
            end
          end

          context "when `scope` is `:instance`" do
            let(:scope) { :instance }

            it "returns valid namespace name" do
              expect(command_result).to eq(:ImportedIncludedInstanceMethods)
            end
          end
        end

        context "when `scope` is NOT valid" do
          let(:scope) { nil }

          it "returns namespace name without `scope` value" do
            expect(command_result).to eq(:ImportedIncludedMethods)
          end
        end
      end

      describe "prepend" do
        context "when `prepend` is valid" do
          context "when `prepend` is `false`" do
            it "returns valid namespace name" do
              expect(command_result).to eq(:ImportedIncludedClassMethods)
            end
          end

          context "when `prepend` is `true`" do
            let(:prepend) { true }

            it "returns valid namespace name" do
              expect(command_result).to eq(:ImportedPrependedClassMethods)
            end
          end
        end

        context "when `prepend` is NOT valid" do
          let(:prepend) { nil }

          it "behaves like `include`" do
            expect(command_result).to eq(:ImportedIncludedClassMethods)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

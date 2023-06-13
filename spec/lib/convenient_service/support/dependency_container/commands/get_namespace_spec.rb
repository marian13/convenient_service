# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::GetNamespace do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(importing_module: importing_module, scope: scope, prepend: prepend) }

      before do
        importing_module.import(method, from: container, scope: :class)
      end

      let(:scope) { :class }
      let(:prepend) { false }
      let(:method) { :bar }

      let(:importing_module) do
        Class.new do
          include ConvenientService::Support::DependencyContainer::Import
        end
      end

      let(:container) do
        Module.new do
          include ConvenientService::Support::DependencyContainer::Export

          export :bar, scope: :class do
            "bar with :class scope"
          end
        end
      end

      context "when namespace exists" do
        it "returns namespace" do
          expect(command_result).to eq(importing_module::ImportedIncludedClassMethods)
        end
      end

      context "when namespace does NOT exist" do
        let(:scope) { :instance }
        let(:prepend) { true }

        it "returns `nil`" do
          expect(command_result).to be_nil
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

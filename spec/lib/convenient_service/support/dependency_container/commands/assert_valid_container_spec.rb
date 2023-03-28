# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(container: container) }

      context "when `container` does NOT include `ConvenientService::DependencyContainer::Export`" do
        let(:container) { Module.new }

        let(:error_message) do
          <<~TEXT
            Module `#{container}` can NOT export methods.

            Did you forget to include `ConvenientService::DependencyContainer::Export` into it?
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Errors::NotExportableModule`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Errors::NotExportableModule)
            .with_message(error_message)
        end
      end

      context "when `container` includes `ConvenientService::DependencyContainer::Export`" do
        let(:container) do
          Module.new do
            include ConvenientService::DependencyContainer::Export
          end
        end

        it "does NOT raise" do
          expect { command_result }.not_to raise_error
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(container: container) }

      context "when `container` does NOT include `ConvenientService::DependencyContainer::Export`" do
        let(:container) { Module.new }

        let(:exception_message) do
          <<~TEXT
            Module `#{container}` can NOT export methods.

            Did you forget to include `ConvenientService::DependencyContainer::Export` into it?
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Exceptions::NotExportableModule`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotExportableModule)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(ConvenientService::Support::DependencyContainer::Exceptions::NotExportableModule) { command_result } }
            .to delegate_to(ConvenientService, :raise)
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

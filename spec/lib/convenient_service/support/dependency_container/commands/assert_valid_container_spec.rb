# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidContainer, type: :standard do
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

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { command_result }.to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::NotExportableModule)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
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

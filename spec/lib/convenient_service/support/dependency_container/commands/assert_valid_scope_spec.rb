# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidScope, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(scope: scope) }

      context "when `scope` is NOT valid" do
        let(:scope) { :foo }

        let(:exception_message) do
          <<~TEXT
            Scope `#{scope.inspect}` is NOT valid.

            Valid options are `:instance`, `:class`.
          TEXT
        end

        it "raises `ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope`" do
          expect { command_result }
            .to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope)
            .with_message(exception_message)
        end

        ##
        # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
        #
        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
        specify do
          expect(ConvenientService).to receive(:raise).and_call_original

          expect { command_result }.to raise_error(ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope)
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      end

      context "when `scope` is valid" do
        context "when `scope` is `:instance`" do
          let(:scope) { :instance }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end

        context "when `scope` is `:class`" do
          let(:scope) { :class }

          it "does NOT raise" do
            expect { command_result }.not_to raise_error
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

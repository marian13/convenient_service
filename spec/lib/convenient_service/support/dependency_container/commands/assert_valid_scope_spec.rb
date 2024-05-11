# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::DependencyContainer::Commands::AssertValidScope, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

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

        specify do
          expect { ignoring_exception(ConvenientService::Support::DependencyContainer::Exceptions::InvalidScope) { command_result } }
            .to delegate_to(ConvenientService, :raise)
        end
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

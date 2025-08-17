# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Helpers::Classes::IgnoringException, type: :standard do
  include ConvenientService::RSpec::Helpers::IgnoringException

  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "instance methods" do
    describe "#call" do
      let(:command_result) { described_class.call(exception, &block) }
      let(:exception) { Class.new(StandardError) }

      context "when `exception` is NOT raised" do
        let(:block) { proc {} }

        let(:exception_message) do
          <<~TEXT
            Exception `#{exception}` is NOT raised. That is why it is NOT ignored.
          TEXT
        end

        it "raises `ConvenientService::RSpec::Helpers::Classes::IgnoringException::Exceptions::IgnoredExceptionIsNotRaised`" do
          expect { command_result }
            .to raise_error(described_class::Exceptions::IgnoredExceptionIsNotRaised)
            .with_message(exception_message)
        end

        specify do
          expect { ignoring_exception(described_class::Exceptions::IgnoredExceptionIsNotRaised) { command_result } }
            .to delegate_to(ConvenientService, :raise)
        end
      end

      context "when `exception` is raised" do
        let(:block) { proc { raise exception } }

        it "returns `ConvenientService::Support::UNDEFINED`" do
          expect(command_result).to eq(ConvenientService::Support::UNDEFINED)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

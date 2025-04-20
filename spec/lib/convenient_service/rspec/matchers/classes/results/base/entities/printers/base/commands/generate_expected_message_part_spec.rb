# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base::Commands::GenerateExpectedMessagePart, type: :standard do
  include ConvenientService::RSpec::Matchers::Results

  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(printer: matcher.printer) }

      context "when matcher is NOT chained by `with_message`" do
        let(:matcher) { be_success }

        it "returns empty string" do
          expect(command_result).to eq("")
        end
      end

      context "when matcher is chained by `with_message`" do
        let(:matcher) { be_error.with_message(message) }
        let(:message) { {foo: :bar} }

        it "returns part with message" do
          expect(command_result).to eq("with message `#{message}`")
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

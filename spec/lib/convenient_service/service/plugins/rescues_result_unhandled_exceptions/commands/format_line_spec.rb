# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Service::Plugins::RescuesResultUnhandledExceptions::Commands::FormatLine, type: :standard do
  example_group "class methods" do
    describe ".call" do
      subject(:command_result) { described_class.call(line: line) }

      let(:line) { "/gem/lib/convenient_service/factories/services.rb:120:in `result'" }
      let(:formatted_line) { "# #{line}" }

      it "returns formatted line" do
        expect(command_result).to eq(formatted_line)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Entities::Logger, type: :standard do
  example_group "class methods" do
    describe ".log" do
      let(:out) { Tempfile.new }
      let(:message) { "foo" }

      it "returns message" do
        expect(described_class.log(message, out: out)).to eq(message)
      end

      it "puts message" do
        described_class.log(message, out: out)

        expect(out.tap(&:rewind).read).to eq("#{message}\n")
      end

      context "when `out` is NOT passed" do
        it "defaults to `$stdout`" do
          expect { described_class.log(message) }.to output("#{message}\n").to_stdout
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

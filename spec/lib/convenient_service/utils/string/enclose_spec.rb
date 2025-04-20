# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::String::Enclose, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(string, char) }

    let(:string) { "foo" }
    let(:char) { "_" }

    context "when `string` is `nil`" do
      let(:string) { nil }

      it "returns `char`" do
        expect(util_result).to eq(char)
      end
    end

    context "when `string` is NOT empty" do
      let(:string) { "foo" }

      it "returns `string` enclosed by `char`" do
        expect(util_result).to eq("#{char}#{string}#{char}")
      end
    end

    context "when `string` is empty" do
      let(:string) { "" }

      it "returns empty array" do
        expect(util_result).to eq(char)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::V1::RequestParams::Utils::JSON::SafeParse, type: :standard do
  describe ".call" do
    let(:default_value) { "some default value" }

    shared_examples "respects default value" do
      context "when default value is passed" do
        it "returns that default value" do
          expect(described_class.call(json_string, default_value: default_value)).to eq(default_value)
        end
      end
    end

    context "when json string is nil" do
      let(:json_string) { nil }

      it "returns nil" do
        expect(described_class.call(json_string)).to be_nil
      end

      it_behaves_like "respects default value"
    end

    context "when json string is NOT string" do
      let(:json_string) { ["array"] }

      it "returns nil" do
        expect(described_class.call(json_string)).to be_nil
      end

      it_behaves_like "respects default value"
    end

    context "when json string is NOT valid json" do
      let(:json_string) { "invalid json string" }

      it "returns nil" do
        expect(described_class.call(json_string)).to be_nil
      end

      it_behaves_like "respects default value"
    end

    context "when json string is valid json" do
      let(:json_string) { "{\"valid\":\"json\"}" }

      it "returns json" do
        expect(described_class.call(json_string)).to eq({"valid" => "json"})
      end
    end
  end
end

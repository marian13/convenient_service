# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::RequestParams::Utils::URL::Valid, type: :standard do
  describe ".call" do
    context "when `url` is `nil`" do
      let(:url) { nil }

      it "returns `false`" do
        expect(described_class.call(url)).to eq(false)
      end
    end

    context "when `url` is empty string" do
      let(:url) { "" }

      it "returns `false`" do
        expect(described_class.call(url)).to eq(false)
      end
    end

    context "when `url` is invalid URL" do
      let(:url) { "unknown_protocol://example.com" }

      it "returns `false`" do
        expect(described_class.call(url)).to eq(false)
      end
    end

    context "when `url` is HTTP URL" do
      let(:url) { "http://example.com" }

      it "returns `true`" do
        expect(described_class.call(url)).to eq(true)
      end
    end

    context "when `url` is HTTPS URL" do
      let(:url) { "https://example.com" }

      it "returns `true`" do
        expect(described_class.call(url)).to eq(true)
      end
    end
  end
end

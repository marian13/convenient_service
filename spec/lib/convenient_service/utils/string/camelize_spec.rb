# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::String::Camelize, type: :standard do
  describe ".call" do
    subject(:result) { described_class.call(string) }

    context "when string do NOT contain any special chars" do
      let(:string) { "foo" }

      it "returns camelized string" do
        expect(result).to eq("Foo")
      end
    end

    context "when string contains colon" do
      let(:string) { "foo:bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains underscore" do
      let(:string) { "foo_bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains question mark" do
      let(:string) { "foo?" }

      it "returns camelized string" do
        expect(result).to eq("Foo")
      end
    end

    context "when string contains exclamation mark" do
      let(:string) { "foo!" }

      it "returns camelized string" do
        expect(result).to eq("Foo")
      end
    end

    context "when string contains dash" do
      let(:string) { "foo-bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains space" do
      let(:string) { "foo bar" }

      it "returns camelized string" do
        expect(result).to eq("FooBar")
      end
    end

    context "when string contains uppercase letter" do
      let(:string) { "bAr" }

      ##
      # NOTE: Does NOT modifies that uppercase letter.
      # https://textedit.tools/camelcase
      #
      it "returns camelized string" do
        expect(result).to eq("BAr")
      end
    end
  end
end

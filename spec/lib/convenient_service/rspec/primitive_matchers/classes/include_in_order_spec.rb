# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::IncludeInOrder, type: :standard do
  subject(:matcher_result) { matcher.matches?(keywords) }

  let(:matcher) { described_class.new(string) }

  let(:string) { "foo bar baz" }
  let(:keywords) { ["foo", "bar", "baz"] }

  let(:printable_keywords) { ["foo", "bar", "baz"].map(&:inspect).join(", ") }

  describe "#matches?" do
    ##
    # TODO: Specs.
    #
    it "returns `true`" do
      expect(matcher_result).to eq(true)
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("include in order #{printable_keywords}")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected `#{string.inspect}` include in order #{printable_keywords}")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected `#{string.inspect}` NOT include in order #{printable_keywords}")
    end
  end
end

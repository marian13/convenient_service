# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::RSpec::Matchers::Classes::IncludeInOrder, type: :standard do
  subject(:matcher_result) { matcher.matches?(string) }

  let(:matcher) { described_class.new(keywords) }

  let(:string) { "foo bar baz" }
  let(:keywords) { ["foo", "bar", "baz"] }

  let(:printable_keywords) { ["foo", "bar", "baz"].map(&:inspect).join(", ") }

  describe "#matches?" do
    context "when `keywords` are NOT empty" do
      context "when `keywords` are strings" do
        let(:keywords) { ["foo", "bar", "baz"] }

        context "when `string` does NOT include `keywords` in order" do
          let(:string) { "foo baz bar" }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `string` includes `keywords` in order" do
          let(:string) { "foo bar baz" }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end
      end

      context "when `keywords` are regular expressios" do
        let(:keywords) { [/foo/, /bar/, /baz/] }

        context "when `string` does NOT include `keywords` in order" do
          let(:string) { "foo baz bar" }

          it "returns `false`" do
            expect(matcher_result).to eq(false)
          end
        end

        context "when `string` includes `keywords` in order" do
          let(:string) { "foo bar baz" }

          it "returns `true`" do
            expect(matcher_result).to eq(true)
          end
        end
      end
    end

    context "when `keywords` are empty" do
      let(:keywords) { [] }

      it "returns `false`" do
        expect(matcher_result).to eq(false)
      end
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
# rubocop:enable RSpec/NestedGroups

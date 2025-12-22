# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::CacheItsValue, type: :standard do
  subject(:matcher_result) { matcher.matches?(block_expectation) }

  let(:matcher) { described_class.new }

  let(:klass) do
    Class.new do
      def foo
        @foo ||= Object.new
      end
    end
  end

  let(:instance) { klass.new }

  let(:block_expectation) { proc { instance.foo } }

  ##
  # NOTE: An example of how RSpec extracts block source, but they marked it as private.
  # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
  #
  # TODO: `printable_block` when `method_source` is available.
  # https://github.com/banister/method_source
  #
  # let(:printable_block) { block_expectation.source }
  #
  let(:printable_block) { "{ ... }" }

  describe "#matches?" do
    context "when block expectation does NOT cache its value (does NOT return same object when called multiple times)" do
      let(:klass) do
        Class.new do
          def foo
            Object.new
          end
        end
      end

      it "returns `false`" do
        expect(matcher_result).to be(false)
      end
    end

    context "when block expectation caches its value (returns same object when called multiple times)" do
      let(:klass) do
        Class.new do
          def foo
            @foo ||= Object.new
          end
        end
      end

      it "returns `true`" do
        expect(matcher_result).to be(true)
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("cache its value")
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected #{printable_block} to cache its value")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected #{printable_block} NOT to cache its value")
    end
  end
end

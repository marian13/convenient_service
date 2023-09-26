# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::Base do
  let(:chaining) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::Matcher.new(object, method) }

  let(:klass) do
    Class.new do
      def foo
        bar
      end

      def bar
        "bar value"
      end
    end
  end

  let(:object) { klass.new }
  let(:method) { :bar }
  let(:block_expectation_value) { Object.new }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { chaining }

    it { is_expected.to have_attr_reader(:matcher) }
    it { is_expected.to have_attr_reader(:block_expectation_value) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `block_expectation_value` is NOT passed" do
        it "defaults to `nil`" do
          expect(chaining.block_expectation_value).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#apply_stubs!" do
      it "returns `nil`" do
        expect(chaining.apply_stubs!).to be_nil
      end
    end

    describe "#matches?" do
      it "sets `block_expectation_value`" do
        chaining.matches?(block_expectation_value)

        expect(chaining.block_expectation_value).to eq(block_expectation_value)
      end

      it "returns `false`" do
        expect(chaining.matches?(block_expectation_value)).to eq(false)
      end
    end

    describe "#does_not_match?" do
      it "sets `block_expectation_value`" do
        chaining.does_not_match?(block_expectation_value)

        expect(chaining.block_expectation_value).to eq(block_expectation_value)
      end

      it "returns opposite of `#matches?`" do
        allow(chaining).to receive(:maches?).and_return(true, false, true, false)

        expect([chaining.does_not_match?(block_expectation_value), !chaining.does_not_match?(block_expectation_value)]).to eq([!chaining.matches?(block_expectation_value), chaining.matches?(block_expectation_value)])
      end
    end

    describe "#failure_message" do
      it "returns empty string" do
        expect(chaining.failure_message).to eq("")
      end
    end

    describe "#failure_message_when_negated" do
      it "returns empty string" do
        expect(chaining.failure_message_when_negated).to eq("")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

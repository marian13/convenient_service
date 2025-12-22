# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Classes::DelegateTo::Entities::SubMatchers::Base, type: :standard do
  let(:sub_matcher) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::Matchers::Classes::DelegateTo.new(object, method) }

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

    subject { sub_matcher }

    it { is_expected.to have_attr_reader(:block_expectation_value) }
    it { is_expected.to have_attr_reader(:matcher) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `block_expectation_value` is NOT passed" do
        it "defaults to `nil`" do
          expect(sub_matcher.block_expectation_value).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#apply_stubs!" do
      it "returns `nil`" do
        expect(sub_matcher.apply_stubs!).to be_nil
      end
    end

    describe "#matches?" do
      it "sets `block_expectation_value`" do
        sub_matcher.matches?(block_expectation_value)

        expect(sub_matcher.block_expectation_value).to eq(block_expectation_value)
      end

      it "returns `false`" do
        expect(sub_matcher.matches?(block_expectation_value)).to be(false)
      end
    end

    describe "#does_not_match?" do
      it "sets `block_expectation_value`" do
        sub_matcher.does_not_match?(block_expectation_value)

        expect(sub_matcher.block_expectation_value).to eq(block_expectation_value)
      end

      it "returns opposite of `#matches?`" do
        allow(sub_matcher).to receive(:maches?).and_return(true, false, true, false)

        expect([sub_matcher.does_not_match?(block_expectation_value), !sub_matcher.does_not_match?(block_expectation_value)]).to eq([!sub_matcher.matches?(block_expectation_value), sub_matcher.matches?(block_expectation_value)])
      end
    end

    describe "#failure_message" do
      it "returns empty string" do
        expect(sub_matcher.failure_message).to eq("")
      end
    end

    describe "#failure_message_when_negated" do
      it "returns empty string" do
        expect(sub_matcher.failure_message_when_negated).to eq("")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

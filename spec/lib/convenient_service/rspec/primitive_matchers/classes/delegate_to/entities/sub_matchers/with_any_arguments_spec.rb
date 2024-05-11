# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# TODO:  with WithArguments.
#
# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithAnyArguments, type: :standard do
  let(:sub_matcher) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method) }

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
  let(:block_expectation) { proc { object.foo } }
  let(:block_expectation_value) { block_expectation.call }

  let(:delegation) do
    ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments) }
  end

  example_group "instance methods" do
    ##
    # NOTE: Tests `matches_arguments?`.
    #
    describe "#matches?" do
      ##
      # NOTE: If it calls `super` then block_expectation_value is set.
      #
      it "calls `super`" do
        sub_matcher.matches?(block_expectation_value)

        expect(sub_matcher.block_expectation_value).to eq(block_expectation_value)
      end

      context "when matcher has NO delegations" do
        before do
          matcher.outputs.delegations.clear
        end

        it "returns `false`" do
          expect(sub_matcher.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when matcher has one delegation" do
        before do
          matcher.outputs.delegations << delegation
        end

        it "returns `true`" do
          expect(sub_matcher.matches?(block_expectation_value)).to eq(true)
        end
      end

      context "when matcher has multiple delegations" do
        before do
          2.times { matcher.outputs.delegations << delegation }
        end

        it "returns `true`" do
          expect(sub_matcher.matches?(block_expectation_value)).to eq(true)
        end
      end
    end

    describe "#matches_arguments?" do
      it "returns `true`" do
        expect(sub_matcher.matches_arguments?(delegation.arguments)).to eq(true)
      end
    end

    describe "#printable_expected_arguments?" do
      let(:printable_expected_arguments) { "with any arguments (no arguments is also valid)" }

      it "returns `true`" do
        expect(sub_matcher.printable_expected_arguments).to eq(printable_expected_arguments)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

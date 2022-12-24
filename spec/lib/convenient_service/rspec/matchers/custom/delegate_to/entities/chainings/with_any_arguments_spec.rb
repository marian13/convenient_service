# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::WithAnyArguments do
  let(:chaining) { described_class.new(matcher: matcher) }

  let(:matcher) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher.new(object, method) }

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
    ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Delegation.new(
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
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Base) }
  end

  example_group "instance methods" do
    describe "#apply_stubs!" do
      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Commands::ApplyStubToTrackDelegations`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Commands::ApplyStubToTrackDelegations).to receive(:call).with(matcher: matcher).and_call_original

        chaining.apply_stubs!

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Commands::ApplyStubToTrackDelegations).to have_received(:call).with(matcher: matcher)
      end
    end

    describe "#matches?" do
      ##
      # NOTE: If it calls `super` then block_expectation_value is set.
      #
      it "calls `super`" do
        chaining.matches?(block_expectation_value)

        expect(chaining.block_expectation_value).to eq(block_expectation_value)
      end

      context "when matcher has NO delegations" do
        before do
          matcher.delegations.clear
        end

        it "returns `false`" do
          expect(chaining.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when matcher has one delegation" do
        before do
          matcher.delegations << delegation
        end

        it "returns `true`" do
          expect(chaining.matches?(block_expectation_value)).to eq(true)
        end
      end

      context "when matcher has multiple delegations" do
        before do
          2.times { matcher.delegations << delegation }
        end

        it "returns `true`" do
          expect(chaining.matches?(block_expectation_value)).to eq(true)
        end
      end
    end

    describe "#failure_message" do
      let(:message) { "expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` with any arguments at least once (no arguments is also valid), but it didn't." }

      it "returns message" do
        expect(chaining.failure_message).to eq(message)
      end
    end

    describe "#failure_message_when_negated" do
      let(:message) { "expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` with any arguments at least once (no arguments is also valid), but it did." }

      it "returns message" do
        expect(chaining.failure_message_when_negated).to eq(message)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
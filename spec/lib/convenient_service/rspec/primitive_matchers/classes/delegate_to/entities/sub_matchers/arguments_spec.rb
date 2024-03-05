# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments do
  let(:sub_matcher_class) do
    Class.new(described_class) do
      def printable_expected_arguments
        "with ()"
      end
    end
  end

  let(:sub_matcher) { sub_matcher_class.new(matcher: matcher) }

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

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Base) }
  end

  example_group "instance methods" do
    describe "#apply_stubs!" do
      it "delegates to `ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::Arguments::Commands::ApplyStubToTrackDelegations`" do
        allow(described_class::Commands::ApplyStubToTrackDelegations).to receive(:call).with(matcher: matcher).and_call_original

        sub_matcher.apply_stubs!

        expect(described_class::Commands::ApplyStubToTrackDelegations).to have_received(:call).with(matcher: matcher)
      end
    end

    ##
    # TODO: `matches?` specs.
    #

    describe "#failure_message" do
      context "when matcher has NO delegations" do
        let(:message) do
          <<~MESSAGE.chomp
            expected `#{matcher.inputs.printable_block_expectation}` to delegate to `#{matcher.inputs.printable_method}` #{sub_matcher.printable_expected_arguments} at least once, but it didn't.

            got not delegated at all
          MESSAGE
        end

        before do
          matcher.delegations.clear
        end

        it "returns message" do
          expect(sub_matcher.failure_message).to eq(message)
        end
      end

      context "when matcher has delegations" do
        let(:message) do
          <<~MESSAGE.chomp
            expected `#{matcher.inputs.printable_block_expectation}` to delegate to `#{matcher.inputs.printable_method}` #{sub_matcher.printable_expected_arguments} at least once, but it didn't.

            got delegated #{sub_matcher.printable_actual_arguments}
          MESSAGE
        end

        before do
          matcher.delegations << delegation
        end

        it "returns message" do
          expect(sub_matcher.failure_message).to eq(message)
        end
      end
    end

    describe "#failure_message_when_negated" do
      let(:message) { "expected `#{matcher.inputs.printable_block_expectation}` NOT to delegate to `#{matcher.inputs.printable_method}` #{sub_matcher.printable_expected_arguments} at least once, but it did." }

      it "returns message" do
        expect(sub_matcher.failure_message_when_negated).to eq(message)
      end
    end

    describe "#printable_actual_arguments" do
      context "when matcher has NO delegations" do
        let(:printable_arguments) { "" }

        it "returns empty string" do
          expect(sub_matcher.printable_actual_arguments).to eq(printable_arguments)
        end
      end

      context "when matcher has one delegation" do
        let(:printable_arguments) { described_class::Commands::GeneratePrintableArguments.call(arguments: matcher.delegations.first.arguments).prepend("with ") }

        before do
          matcher.delegations << delegation
        end

        it "returns printable arguments for that delegation" do
          expect(sub_matcher.printable_actual_arguments).to eq(printable_arguments)
        end
      end

      context "when matcher has multiple delegations" do
        let(:printable_arguments) do
          matcher.delegations
            .map { |delegation| described_class::Commands::GeneratePrintableArguments.call(arguments: delegation.arguments) }
            .join(", ")
            .prepend("with ")
        end

        before do
          2.times { matcher.delegations << delegation }
        end

        it "returns printable arguments concatted by command for those delegations" do
          expect(sub_matcher.printable_actual_arguments).to eq(printable_arguments)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

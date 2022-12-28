# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithConcreteArguments do
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

  let(:expected_arguments) { ConvenientService::Support::Arguments.new(*args, **kwargs, &block) }

  let(:delegation_with_expected_arguments) do
    ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Delegation.new(
      object: object,
      method: method,
      args: args,
      kwargs: kwargs,
      block: block
    )
  end

  let(:delegation_with_not_expected_arguments) do
    ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Delegation.new(
      object: object,
      method: method,
      args: [:bar],
      kwargs: {bar: :baz},
      block: proc { :bar }
    )
  end

  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::Base) }
  end

  example_group "instance methods" do
    describe "#apply_stubs!" do
      it "delegates to `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithArguments::Commands::ApplyStubToTrackDelegations`" do
        allow(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithArguments::Commands::ApplyStubToTrackDelegations).to receive(:call).with(matcher: matcher).and_call_original

        chaining.apply_stubs!

        expect(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Matchers::WithArguments::Commands::ApplyStubToTrackDelegations).to have_received(:call).with(matcher: matcher)
      end
    end

    describe "#matches?" do
      context "when matcher expected arguments are NOT set" do
        ##
        # NOTE: If it calls `super` then block_expectation_value is set.
        #
        it "calls `super`" do
          chaining.matches?(block_expectation_value)

          expect(chaining.block_expectation_value).to eq(block_expectation_value)
        end

        it "returns `false`" do
          expect(chaining.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when matcher expected arguments are set" do
        before do
          matcher.expected_arguments = expected_arguments
        end

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
          context "when that one delegation has NOT expected arguments" do
            before do
              matcher.delegations << delegation_with_not_expected_arguments
            end

            it "returns `false`" do
              expect(chaining.matches?(block_expectation_value)).to eq(false)
            end
          end

          context "when that one delegation has expected arguments" do
            before do
              matcher.delegations << delegation_with_expected_arguments
            end

            it "returns `true`" do
              expect(chaining.matches?(block_expectation_value)).to eq(true)
            end
          end
        end

        context "when matcher has multiple delegations" do
          context "when all those multiple delegations have NOT expected arguments" do
            before do
              2.times { matcher.delegations << delegation_with_not_expected_arguments }
            end

            it "returns `false`" do
              expect(chaining.matches?(block_expectation_value)).to eq(false)
            end
          end

          context "when any of those multiple delegations has expected arguments" do
            before do
              matcher.delegations << delegation_with_not_expected_arguments

              matcher.delegations << delegation_with_expected_arguments
            end

            it "returns `true`" do
              expect(chaining.matches?(block_expectation_value)).to eq(true)
            end
          end
        end
      end
    end

    describe "#failure_message" do
      context "when matcher has NO delegations" do
        let(:message) do
          <<~MESSAGE.chomp
            expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` #{chaining.printable_expected_arguments} at least once, but it didn't.

            got not delegated at all
          MESSAGE
        end

        before do
          matcher.delegations.clear
        end

        it "returns message" do
          expect(chaining.failure_message).to eq(message)
        end
      end

      context "when matcher has delegations" do
        let(:message) do
          <<~MESSAGE.chomp
            expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` #{chaining.printable_expected_arguments} at least once, but it didn't.

            got delegated #{chaining.printable_actual_arguments}
          MESSAGE
        end

        before do
          matcher.delegations << delegation_with_not_expected_arguments
        end

        it "returns message" do
          expect(chaining.failure_message).to eq(message)
        end
      end
    end

    describe "#failure_message_when_negated" do
      it "returns message" do
        expect(chaining.failure_message_when_negated).to eq("expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` #{chaining.printable_expected_arguments} at least once, but it did.")
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

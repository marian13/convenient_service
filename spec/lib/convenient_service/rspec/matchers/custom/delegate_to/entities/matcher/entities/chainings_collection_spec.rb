# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection do
  let(:chainings_collection) { described_class.new(matcher: matcher) }
  let(:matcher) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher.new(object, method, block_expectation) }

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

  let(:arguments_chaining) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::WithAnyArguments.new(matcher: matcher) }
  let(:return_its_value_chaining) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::SubMatchers::ReturnItsValue.new(matcher: matcher) }

  let(:without_calling_original_chaining) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Values::WithoutCallingOriginal.new(matcher: matcher) }
  let(:with_calling_original_chaining) { ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Values::WithCallingOriginal.new(matcher: matcher) }
  let(:call_original_chaining) { with_calling_original_chaining }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { chainings_collection }

    it { is_expected.to have_attr_reader(:matcher) }
    it { is_expected.to have_attr_reader(:block_expectation_value) }
    it { is_expected.to have_attr_reader(:call_original) }
    it { is_expected.to have_attr_reader(:arguments) }
    it { is_expected.to have_attr_reader(:return_its_value) }
  end

  example_group "instance methods" do
    describe "#sub_matchers_match?" do
      it "sets block expectation value" do
        chainings_collection.sub_matchers_match?(block_expectation)

        expect(block_expectation_value).to eq(block_expectation.call)
      end

      context "when NO chaining is used" do
        it "returns `true`" do
          expect(chainings_collection.sub_matchers_match?(block_expectation)).to eq(true)
        end
      end

      context "when arguments chaining is used" do
        before do
          chainings_collection.arguments = arguments_chaining
        end

        it "applies arguments chaining stubs" do
          allow(chainings_collection.arguments).to receive(:apply_stubs!).and_call_original

          chainings_collection.sub_matchers_match?(block_expectation)

          expect(chainings_collection.arguments).to have_received(:apply_stubs!)
        end

        context "when arguments chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.sub_matchers_match?(block_expectation)).to eq(false)
          end
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = return_its_value_chaining
        end

        it "applies return its value chaining stubs" do
          allow(chainings_collection.return_its_value).to receive(:apply_stubs!).and_call_original

          chainings_collection.sub_matchers_match?(block_expectation)

          expect(chainings_collection.return_its_value).to have_received(:apply_stubs!)
        end

        context "when return its value chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.sub_matchers_match?(block_expectation)).to eq(false)
          end
        end
      end

      context "when multiple chainings is used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.call_original = call_original_chaining

          chainings_collection.return_its_value = return_its_value_chaining
        end

        context "when any of those chainigns does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.sub_matchers_match?(block_expectation)).to eq(false)
          end
        end

        context "when all of those chainigns match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns `true`" do
            expect(chainings_collection.sub_matchers_match?(block_expectation)).to eq(true)
          end
        end
      end
    end

    describe "#should_call_original?" do
      context "when chaining collection does NOT have call original chaining" do
        it "returns `false`" do
          expect(chainings_collection.should_call_original?).to eq(false)
        end
      end

      context "when chaining collection has call original chaining" do
        context "when that call original chaining tells NOT to call original" do
          before do
            chainings_collection.call_original = without_calling_original_chaining
          end

          it "returns `false`" do
            expect(chainings_collection.should_call_original?).to eq(false)
          end
        end

        context "when that call original chaining tells to call original" do
          before do
            chainings_collection.call_original = with_calling_original_chaining
          end

          it "returns `true`" do
            expect(chainings_collection.should_call_original?).to eq(true)
          end
        end
      end
    end

    describe "#failure_message" do
      context "when NO chaining is used" do
        it "returns empty string" do
          expect(chainings_collection.failure_message).to eq("")
        end
      end

      context "when arguments chaining is used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when arguments chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns arguments chaining failure message" do
            expect(chainings_collection.failure_message).to eq(chainings_collection.arguments.failure_message)
          end
        end

        context "when arguments chaining matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(chainings_collection.failure_message).to eq("")
          end
        end
      end

      context "when call original chaining is used" do
        before do
          chainings_collection.call_original = call_original_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        it "returns empty string" do
          expect(chainings_collection.failure_message).to eq("")
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = return_its_value_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when return its value chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns return its value chaining failure message" do
            expect(chainings_collection.failure_message).to eq(chainings_collection.return_its_value.failure_message)
          end
        end

        context "when return its value chaining matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(chainings_collection.failure_message).to eq("")
          end
        end
      end

      context "when multiple chainings is used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.call_original = call_original_chaining

          chainings_collection.return_its_value = return_its_value_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when any of those chainigns does NOT match" do
          let(:block_expectation) { proc { object } }
          let(:first_not_matched_chaining) { chainings_collection.sub_matchers.find { |sub_matcher| sub_matcher.does_not_match?(block_expectation_value) } }

          it "returns failure message of the first NOT matched chaining" do
            expect(chainings_collection.failure_message).to eq(first_not_matched_chaining.failure_message)
          end
        end

        context "when all of those chainigns match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(chainings_collection.failure_message).to eq("")
          end
        end
      end
    end

    describe "#failure_message_when_negated" do
      context "when NO chaining is used" do
        it "returns empty string" do
          expect(chainings_collection.failure_message_when_negated).to eq("")
        end
      end

      context "when arguments chaining is used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when arguments chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(chainings_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when arguments chaining matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns arguments chaining failure message when negated" do
            expect(chainings_collection.failure_message_when_negated).to eq(chainings_collection.arguments.failure_message_when_negated)
          end
        end
      end

      context "when call original chaining is used" do
        before do
          chainings_collection.call_original = call_original_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        it "returns empty string" do
          expect(chainings_collection.failure_message_when_negated).to eq("")
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = return_its_value_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when return its value chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(chainings_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when return its value chaining matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns return its value chaining failure message when negated" do
            expect(chainings_collection.failure_message_when_negated).to eq(chainings_collection.return_its_value.failure_message_when_negated)
          end
        end
      end

      context "when multiple chainings is used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.call_original = call_original_chaining

          chainings_collection.return_its_value = return_its_value_chaining

          chainings_collection.sub_matchers_match?(block_expectation)
        end

        context "when all of those chainigns do NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(chainings_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when any of those chainigns match" do
          let(:block_expectation) { proc { object.foo } }
          let(:last_matched_chaining) { chainings_collection.sub_matchers.reverse.find { |sub_matcher| sub_matcher.matches?(block_expectation_value) } }

          it "returns failure message when negated of the last matched chaining" do
            expect(chainings_collection.failure_message_when_negated).to eq(last_matched_chaining.failure_message_when_negated)
          end
        end
      end
    end

    describe "#sub_matchers" do
      context "when any type of matcher chainings is missed" do
        before do
          chainings_collection.return_its_value = return_its_value_chaining
        end

        it "returns ordered matcher chainings skipping that missed matcher chaining" do
          expect(chainings_collection.sub_matchers).to eq([chainings_collection.return_its_value])
        end
      end

      context "when all types of matcher chainings are used" do
        before do
          chainings_collection.arguments = arguments_chaining

          chainings_collection.return_its_value = return_its_value_chaining
        end

        it "returns ordered matcher chainings" do
          expect(chainings_collection.sub_matchers).to eq([chainings_collection.arguments, chainings_collection.return_its_value])
        end
      end
    end

    describe "#values" do
      context "when any type of value chainings is missed" do
        it "returns ordered value chainings skipping that missed value chaining" do
          expect(chainings_collection.values).to eq([])
        end
      end

      context "when all types of value chainings are used" do
        before do
          chainings_collection.call_original = call_original_chaining
        end

        it "returns ordered value chainings" do
          expect(chainings_collection.values).to eq([chainings_collection.call_original])
        end
      end
    end

    describe "#has_call_original?" do
      context "when call original chaining is NOT used" do
        it "returns `false`" do
          expect(chainings_collection.has_call_original?).to eq(false)
        end
      end

      context "when call original chaining is used" do
        before do
          chainings_collection.call_original = call_original_chaining
        end

        it "returns `true`" do
          expect(chainings_collection.has_call_original?).to eq(true)
        end
      end
    end

    describe "#has_arguments?" do
      context "when arguments chaining is NOT used" do
        it "returns `false`" do
          expect(chainings_collection.has_arguments?).to eq(false)
        end
      end

      context "when arguments chaining is used" do
        before do
          chainings_collection.arguments = arguments_chaining
        end

        it "returns `true`" do
          expect(chainings_collection.has_arguments?).to eq(true)
        end
      end
    end

    describe "#has_return_its_value?" do
      context "when return its value chaining is NOT used" do
        it "returns `false`" do
          expect(chainings_collection.has_return_its_value?).to eq(false)
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = return_its_value_chaining
        end

        it "returns `true`" do
          expect(chainings_collection.has_return_its_value?).to eq(true)
        end
      end
    end

    describe "#call_original=" do
      context "when call original chaining is NOT used yet" do
        it "set call_original chaining" do
          chainings_collection.call_original = call_original_chaining

          expect(chainings_collection.call_original).to eq(call_original_chaining)
        end

        it "returns set call original chaining" do
          expect(chainings_collection.call_original = call_original_chaining).to eq(call_original_chaining)
        end
      end

      context "when call original chaining is already used" do
        let(:exception_message) do
          <<~TEXT
            Call original chaining is already set.

            Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
          TEXT
        end

        before do
          chainings_collection.call_original = call_original_chaining
        end

        it "raises error `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::CallOriginalChainingIsAlreadySet`" do
          expect { chainings_collection.call_original = call_original_chaining }
            .to raise_error(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::CallOriginalChainingIsAlreadySet)
            .with_message(exception_message)
        end
      end
    end

    describe "#arguments=" do
      context "when arguments chaining is NOT used yet" do
        it "set arguments chaining" do
          chainings_collection.arguments = arguments_chaining

          expect(chainings_collection.arguments).to eq(arguments_chaining)
        end

        it "returns set arguments chaining" do
          expect(chainings_collection.arguments = arguments_chaining).to eq(arguments_chaining)
        end
      end

      context "when arguments chaining is already used" do
        let(:exception_message) do
          <<~TEXT
            Arguments chaining is already set.

            Did you use `with_arguments` or `without_arguments` multiple times? Or a combination of them?
          TEXT
        end

        before do
          chainings_collection.arguments = arguments_chaining
        end

        it "raises error `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::ArgumentsChainingIsAlreadySet`" do
          expect { chainings_collection.arguments = arguments_chaining }
            .to raise_error(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::ArgumentsChainingIsAlreadySet)
            .with_message(exception_message)
        end
      end
    end

    describe "#return_its_value=" do
      context "when return its value chaining is NOT used yet" do
        it "set return its value chaining" do
          chainings_collection.return_its_value = return_its_value_chaining

          expect(chainings_collection.return_its_value).to eq(return_its_value_chaining)
        end

        it "returns set return its value chaining" do
          expect(chainings_collection.return_its_value = return_its_value_chaining).to eq(return_its_value_chaining)
        end
      end

      context "when return its value chaining is already used" do
        let(:exception_message) do
          <<~TEXT
            Returns its value chaining is already set.

            Did you use `and_returns_its_value` multiple times?
          TEXT
        end

        before do
          chainings_collection.return_its_value = return_its_value_chaining
        end

        it "raises error `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::ReturnItsValueChainingIsAlreadySet`" do
          expect { chainings_collection.return_its_value = return_its_value_chaining }
            .to raise_error(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions::ReturnItsValueChainingIsAlreadySet)
            .with_message(exception_message)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

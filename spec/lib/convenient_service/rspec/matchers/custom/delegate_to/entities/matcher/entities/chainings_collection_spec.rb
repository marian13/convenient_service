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

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

    subject { chainings_collection }

    it { is_expected.to have_attr_reader(:matcher) }
    it { is_expected.to have_attr_reader(:block_expectation_value) }
  end

  example_group "instance methods" do
    describe "#matches?" do
      it "sets block expectation value" do
        chainings_collection.matches?(block_expectation)

        expect(block_expectation_value).to eq(block_expectation.call)
      end

      context "when NO chaining is used" do
        it "returns `true`" do
          expect(chainings_collection.matches?(block_expectation)).to eq(true)
        end
      end

      context "when arguments chaining is used" do
        before do
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)
        end

        it "applies arguments chaining stubs" do
          allow(chainings_collection.arguments).to receive(:apply_stubs!).and_call_original

          chainings_collection.matches?(block_expectation)

          expect(chainings_collection.arguments).to have_received(:apply_stubs!)
        end

        context "when arguments chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.matches?(block_expectation)).to eq(false)
          end
        end
      end

      context "when call original chaining is used" do
        before do
          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)
        end

        it "applies call original chaining stubs" do
          allow(chainings_collection.call_original).to receive(:apply_stubs!).and_call_original

          chainings_collection.matches?(block_expectation)

          expect(chainings_collection.call_original).to have_received(:apply_stubs!)
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)
        end

        it "applies return its value chaining stubs" do
          allow(chainings_collection.return_its_value).to receive(:apply_stubs!).and_call_original

          chainings_collection.matches?(block_expectation)

          expect(chainings_collection.return_its_value).to have_received(:apply_stubs!)
        end

        context "when return its value chaining does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.matches?(block_expectation)).to eq(false)
          end
        end
      end

      context "when multiple chainings is used" do
        before do
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)
        end

        context "when any of those chainigns does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(chainings_collection.matches?(block_expectation)).to eq(false)
          end
        end

        context "when all of those chainigns match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns `true`" do
            expect(chainings_collection.matches?(block_expectation)).to eq(true)
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
            chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithoutCallingOriginal.new(matcher: matcher)
          end

          it "returns `false`" do
            expect(chainings_collection.should_call_original?).to eq(false)
          end
        end

        context "when that call original chaining tells to call original" do
          before do
            chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)
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
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
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
          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
        end

        it "returns empty string" do
          expect(chainings_collection.failure_message).to eq("")
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
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
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
        end

        context "when any of those chainigns does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns failure message of the first NOT matched chaining" do
            expect(chainings_collection.failure_message).to eq(chainings_collection.ordered_chainings.find { |chaining| chaining.does_not_match?(block_expectation) }.failure_message)
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
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
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
          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
        end

        it "returns empty string" do
          expect(chainings_collection.failure_message_when_negated).to eq("")
        end
      end

      context "when return its value chaining is used" do
        before do
          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
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
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)

          chainings_collection.matches?(block_expectation)
        end

        context "when any of those chainigns does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(chainings_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when all of those chainigns match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns failure message when negated of the first NOT matched chaining" do
            expect(chainings_collection.failure_message_when_negated).to eq(chainings_collection.ordered_chainings.find { |chaining| chaining.matches?(block_expectation) }.failure_message_when_negated)
          end
        end
      end
    end

    describe "#ordered_chainings" do
      context "when any type of chainings is missed" do
        before do
          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)
        end

        it "returns ordered chainings skipping that missed chaining" do
          expect(chainings_collection.ordered_chainings).to eq([chainings_collection.call_original, chainings_collection.return_its_value])
        end
      end

      context "when all types of chainings are used" do
        before do
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)

          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)

          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)
        end

        it "returns ordered chainings" do
          expect(chainings_collection.ordered_chainings).to eq([chainings_collection.call_original, chainings_collection.arguments, chainings_collection.return_its_value])
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
          chainings_collection.call_original = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal.new(matcher: matcher)
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
          chainings_collection.arguments = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithAnyArguments.new(matcher: matcher)
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
          chainings_collection.return_its_value = ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::ReturnItsValue.new(matcher: matcher)
        end

        it "returns `true`" do
          expect(chainings_collection.has_return_its_value?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

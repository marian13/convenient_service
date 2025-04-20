# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatcherCollection, type: :standard do
  include ConvenientService::RSpec::PrimitiveHelpers::IgnoringException

  let(:sub_matcher_collection) { described_class.new(matcher: matcher) }
  let(:matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo.new(object, method, block_expectation) }

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

  let(:without_arguments_sub_matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithoutArguments.new(matcher: matcher) }
  let(:with_any_arguments_sub_matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithAnyArguments.new(matcher: matcher) }
  let(:with_concrete_arguments_sub_matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithConcreteArguments.new(matcher: matcher) }

  let(:return_its_value_sub_matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnDelegationValue.new(matcher: matcher) }
  let(:return_custom_value_sub_matcher) { ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::ReturnCustomValue.new(matcher: matcher) }

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { sub_matcher_collection }

    it { is_expected.to have_attr_reader(:block_expectation_value) }
    it { is_expected.to have_attr_reader(:matcher) }
    it { is_expected.to have_attr_reader(:sub_matchers) }
  end

  example_group "instance methods" do
    describe "#matches?" do
      it "sets block expectation value" do
        sub_matcher_collection.matches?(block_expectation)

        expect(block_expectation_value).to eq(block_expectation.call)
      end

      context "when NO `sub_matcher` is used" do
        it "returns `true`" do
          expect(sub_matcher_collection.matches?(block_expectation)).to eq(true)
        end
      end

      context "when arguments `sub_matcher` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher
        end

        it "applies arguments `sub_matcher` stubs" do
          allow(sub_matcher_collection.arguments).to receive(:apply_stubs!).and_call_original

          sub_matcher_collection.matches?(block_expectation)

          expect(sub_matcher_collection.arguments).to have_received(:apply_stubs!)
        end

        context "when arguments `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(sub_matcher_collection.matches?(block_expectation)).to eq(false)
          end
        end
      end

      context "when return value `sub_matcher` is used" do
        before do
          sub_matcher_collection.return_value = return_its_value_sub_matcher
        end

        it "applies return value `sub_matcher` stubs" do
          allow(sub_matcher_collection.return_value).to receive(:apply_stubs!).and_call_original

          sub_matcher_collection.matches?(block_expectation)

          expect(sub_matcher_collection.return_value).to have_received(:apply_stubs!)
        end

        context "when return value `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(sub_matcher_collection.matches?(block_expectation)).to eq(false)
          end
        end
      end

      context "when multiple `sub_matchers` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.return_value = return_its_value_sub_matcher
        end

        context "when any of those `sub_matchers` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns `false`" do
            expect(sub_matcher_collection.matches?(block_expectation)).to eq(false)
          end
        end

        context "when all of those `sub_matchers` match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns `true`" do
            expect(sub_matcher_collection.matches?(block_expectation)).to eq(true)
          end
        end
      end
    end

    describe "#failure_message" do
      context "when NO `sub_matcher` is used" do
        it "returns `with_any_arguments` chainin failure message" do
          expect(sub_matcher_collection.failure_message).to eq(with_any_arguments_sub_matcher.failure_message)
        end
      end

      context "when arguments `sub_matcher` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when arguments `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns arguments `sub_matcher` failure message" do
            expect(sub_matcher_collection.failure_message).to eq(sub_matcher_collection.arguments.failure_message)
          end
        end

        context "when arguments `sub_matcher` matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message).to eq("")
          end
        end
      end

      context "when return its value `sub_matcher` is used" do
        before do
          sub_matcher_collection.return_value = return_its_value_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when return its value `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { [object.foo] } }

          it "returns return its value `sub_matcher` failure message" do
            expect(sub_matcher_collection.failure_message).to eq(sub_matcher_collection.return_value.failure_message)
          end
        end

        context "when return its value `sub_matcher` matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message).to eq("")
          end
        end
      end

      context "when multiple `sub_matchers` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.return_value = return_its_value_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when any of those `sub_matchers` does NOT match" do
          let(:block_expectation) { proc { object } }
          let(:first_not_matched_sub_matcher) { sub_matcher_collection.sub_matchers_ordered_by_index.find { |sub_matcher| sub_matcher.does_not_match?(block_expectation_value) } }

          it "returns failure message of the first NOT matched `sub_matcher`" do
            expect(sub_matcher_collection.failure_message).to eq(first_not_matched_sub_matcher.failure_message)
          end
        end

        context "when all of those `sub_matchers` match" do
          let(:block_expectation) { proc { object.foo } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message).to eq("")
          end
        end
      end
    end

    describe "#failure_message_when_negated" do
      context "when NO `sub_matcher` is used" do
        it "returns empty string" do
          expect(sub_matcher_collection.failure_message_when_negated).to eq("")
        end
      end

      context "when arguments `sub_matcher` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when arguments `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when arguments `sub_matcher` matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns arguments `sub_matcher` failure message when negated" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq(sub_matcher_collection.arguments.failure_message_when_negated)
          end
        end
      end

      context "when return its value `sub_matcher` is used" do
        before do
          sub_matcher_collection.return_value = return_its_value_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when return its value `sub_matcher` does NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when return its value `sub_matcher` matches" do
          let(:block_expectation) { proc { object.foo } }

          it "returns return its value `sub_matcher` failure message when negated" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq(sub_matcher_collection.return_value.failure_message_when_negated)
          end
        end
      end

      context "when multiple `sub_matchers` is used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.return_value = return_its_value_sub_matcher

          sub_matcher_collection.matches?(block_expectation)
        end

        context "when all of those `sub_matchers` do NOT match" do
          let(:block_expectation) { proc { object } }

          it "returns empty string" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq("")
          end
        end

        context "when any of those `sub_matchers` match" do
          let(:block_expectation) { proc { object.foo } }
          let(:last_matched_sub_matcher) { sub_matcher_collection.sub_matchers_ordered_by_index.reverse.find { |sub_matcher| sub_matcher.matches?(block_expectation_value) } }

          it "returns failure message when negated of the last matched `sub_matcher`" do
            expect(sub_matcher_collection.failure_message_when_negated).to eq(last_matched_sub_matcher.failure_message_when_negated)
          end
        end
      end
    end

    describe "#arguments" do
      context "when `arguments` sub_matcher is NOT set" do
        before do
          sub_matcher_collection.sub_matchers.delete(:arguments)
        end

        it "defaults to `with_any_arguments`" do
          expect(sub_matcher_collection.arguments).to be_instance_of(ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::SubMatchers::WithAnyArguments)
        end
      end

      context "when `arguments` sub_matcher is set" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher
        end

        it "return that set sub_matcher" do
          expect(sub_matcher_collection.arguments).to eq(without_arguments_sub_matcher)
        end
      end
    end

    describe "#return_value" do
      context "when `return_value` sub_matcher is NOT set" do
        before do
          sub_matcher_collection.sub_matchers.delete(:return_value)
        end

        it "returns `nil`" do
          expect(sub_matcher_collection.return_value).to be_nil
        end
      end

      context "when `return_value` sub_matcher is set" do
        before do
          sub_matcher_collection.return_value = return_custom_value_sub_matcher
        end

        it "return that set sub_matcher" do
          expect(sub_matcher_collection.return_value).to eq(return_custom_value_sub_matcher)
        end
      end
    end

    describe "#sub_matchers_ordered_by_index" do
      context "when any type of matcher `sub_matchers` is missed" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher
        end

        it "returns ordered matcher `sub_matchers` skipping that missed matcher `sub_matcher`" do
          expect(sub_matcher_collection.sub_matchers_ordered_by_index).to eq([sub_matcher_collection.arguments])
        end
      end

      context "when all types of matcher `sub_matchers` are used" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher

          sub_matcher_collection.return_value = return_its_value_sub_matcher
        end

        it "returns ordered matcher `sub_matchers`" do
          expect(sub_matcher_collection.sub_matchers_ordered_by_index).to eq([sub_matcher_collection.arguments, sub_matcher_collection.return_value])
        end
      end
    end

    describe "#has_arguments?" do
      context "when `arguments` sub_matcher is NOT set" do
        before do
          sub_matcher_collection.sub_matchers.delete(:arguments)
        end

        it "returns `false`" do
          expect(sub_matcher_collection.has_arguments?).to eq(false)
        end
      end

      context "when `arguments` sub_matcher is set" do
        before do
          sub_matcher_collection.arguments = without_arguments_sub_matcher
        end

        it "returns `true`" do
          expect(sub_matcher_collection.has_arguments?).to eq(true)
        end
      end
    end

    describe "#has_return_value?" do
      context "when `return_value` sub_matcher is NOT set" do
        before do
          sub_matcher_collection.sub_matchers.delete(:return_value)
        end

        it "returns `false`" do
          expect(sub_matcher_collection.has_return_value?).to eq(false)
        end
      end

      context "when `return_value` sub_matcher is set" do
        before do
          sub_matcher_collection.return_value = return_custom_value_sub_matcher
        end

        it "returns `true`" do
          expect(sub_matcher_collection.has_return_value?).to eq(true)
        end
      end
    end

    describe "#arguments=" do
      it "set arguments `sub_matcher`" do
        sub_matcher_collection.arguments = without_arguments_sub_matcher

        expect(sub_matcher_collection.arguments).to eq(without_arguments_sub_matcher)
      end

      it "returns set arguments `sub_matcher`" do
        expect(sub_matcher_collection.arguments = without_arguments_sub_matcher).to eq(without_arguments_sub_matcher)
      end
    end

    describe "#return_value=" do
      it "set return its value `sub_matcher`" do
        sub_matcher_collection.return_value = return_its_value_sub_matcher

        expect(sub_matcher_collection.return_value).to eq(return_its_value_sub_matcher)
      end

      it "returns set return its value `sub_matcher`" do
        expect(sub_matcher_collection.return_value = return_its_value_sub_matcher).to eq(return_its_value_sub_matcher)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

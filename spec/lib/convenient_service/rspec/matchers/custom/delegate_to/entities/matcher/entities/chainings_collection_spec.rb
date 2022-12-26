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
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::WithCallingOriginal do
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

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::Chainings::Base) }
  end

  example_group "instance methods" do
    describe "#matches?" do
      ##
      # NOTE: If it calls `super` then block_expectation_value is set.
      #
      it "calls `super`" do
        chaining.matches?(block_expectation_value)

        expect(chaining.block_expectation_value).to eq(block_expectation_value)
      end

      it "returns `true`" do
        expect(chaining.matches?(block_expectation_value)).to eq(true)
      end
    end

    describe "#should_call_original?" do
      it "returns `true`" do
        expect(chaining.should_call_original?).to eq(true)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::ReturnItsValue do
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

  let(:delegation_value) { object.foo }

  example_group "inheritance" do
    include ConvenientService::RSpec::Matchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Chainings::Base) }
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

      context "when block expectation value does NOT equal to return value of method invocation on object" do
        let(:block_expectation) { proc { 42 } }

        it "returns `false`" do
          expect(chaining.matches?(block_expectation_value)).to eq(false)
        end
      end

      context "when block expectation value equals to return value of method invocation on object" do
        let(:block_expectation) { proc { object.foo } }

        it "returns `true`" do
          expect(chaining.matches?(block_expectation_value)).to eq(true)
        end
      end
    end

    describe "#failure_message" do
      let(:chaining) { described_class.new(matcher: matcher, block_expectation_value: block_expectation_value) }

      let(:message) do
        <<~MESSAGE.chomp
          expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` and return its value, but it didn't.

          `#{matcher.printable_block_expectation}` returns `#{block_expectation_value.inspect}`, but delegation returns `#{delegation_value.inspect}`.
        MESSAGE
      end

      it "returns message" do
        expect(chaining.failure_message).to eq(message)
      end

      context "when block expectation value and return value of method invocation on object have same visual output" do
        let(:klass) do
          Class.new do
            def foo
              bar
            end

            def bar
              self
            end

            ##
            # NOTE: Same inspect for all instances.
            #
            def inspect
              "same visual output"
            end

            ##
            # NOTE: Always false in terms of `#==`.
            #
            def ==(other)
              false
            end
          end
        end

        let(:message_with_note) do
          <<~MESSAGE.chomp
            expected `#{matcher.printable_block_expectation}` to delegate to `#{matcher.printable_method}` and return its value, but it didn't.

            `#{matcher.printable_block_expectation}` returns `#{block_expectation_value.inspect}`, but delegation returns `#{delegation_value.inspect}`.

            NOTE: `#{block_expectation_value.inspect}` and `#{delegation_value.inspect}` have the same visual output, but they are different objects in terms of `#==`.

            If it is expected behavior, ignore this note.

            Otherwise, define a meaningful `#==` for `#{block_expectation_value.class}` or adjust its `#inspect` to generate different output.
          MESSAGE
        end

        it "returns message with note" do
          expect(chaining.failure_message).to eq(message_with_note)
        end
      end
    end

    describe "#failure_message_when_negated" do
      let(:chaining) { described_class.new(matcher: matcher, block_expectation_value: block_expectation_value) }

      let(:message) { "expected `#{matcher.printable_block_expectation}` NOT to delegate to `#{matcher.printable_method}` and return its value, but it did." }

      it "returns message" do
        expect(chaining.failure_message_when_negated).to eq(message)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

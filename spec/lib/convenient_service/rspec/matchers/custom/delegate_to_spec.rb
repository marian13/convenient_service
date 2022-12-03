# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

##
# TODO: Refactor `delegate_to` to NOT use `expect` internally. Then rewrite this spec file completely.
# IMPORTANT: Make sure you have specs when `block_expectation` does NOT delegate at all, delegates once, delegates multiple times.
#
# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo do
  subject(:matcher_result) { matcher.matches?(block_expectation) }

  let(:matcher) { described_class.new(object, method) }

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
  let(:printable_method) { "#{klass}##{method}" }

  ##
  # NOTE: An example of how RSpec extracts block source, but they marked it as private.
  # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
  #
  # TODO: `printable_block_expectation` when `method_source` is available.
  # https://github.com/banister/method_source
  #
  # let(:printable_block_expectation) { block_expectation.source }
  #
  let(:printable_block_expectation) { "{ ... }" }

  describe "#matches?" do
    context "when used without chaining" do
      let(:matcher) { described_class.new(object, method) }

      it "tries to match" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
        #
        matcher_result
      end
    end

    context "when used with `and_return_its_value`" do
      let(:matcher) { described_class.new(object, method).and_return_its_value }

      it "tries to match" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).and_return_its_value`
        #
        matcher_result
      end
    end

    context "when used with `with_arguments(*args, **kwargs, &block)`" do
      let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

      let(:block_expectation) { proc { object.foo(*args, **kwargs, &block) } }

      let(:klass) do
        Class.new do
          def foo(...)
            bar(...)
          end

          def bar(*args, **kwargs, &block)
            [args, kwargs, block]
          end
        end
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      it "tries to match" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar).with_arguments(*args, **kwargs, &block)`
        #
        matcher_result
      end
    end
  end

  describe "#description" do
    it "returns message" do
      matcher_result

      expect(matcher.description).to eq("delegate to `#{printable_method}`")
    end
  end

  describe "#supports_block_expectations?" do
    it "returns `true`" do
      expect(matcher.supports_block_expectations?).to eq(true)
    end
  end

  describe "#printable_method" do
    context "when `object` is class" do
      let(:object) do
        Class.new do
          def self.bar
          end
        end
      end

      let(:method) { :bar }

      it "returns string in 'class.method' format" do
        expect(matcher.printable_method).to eq("#{object}.#{method}")
      end
    end

    context "when `object` is module" do
      let(:object) do
        Module.new do
          def self.bar
          end
        end
      end

      let(:method) { :bar }

      it "returns string in 'module.method' format" do
        expect(matcher.printable_method).to eq("#{object}.#{method}")
      end
    end

    context "when `object` is instance" do
      let(:klass) do
        Class.new do
          def bar
          end
        end
      end

      let(:object) { klass.new }
      let(:method) { :bar }

      it "returns string in 'class#method' format" do
        expect(matcher.printable_method).to eq("#{klass}##{method}")
      end
    end
  end

  describe "#failure_message" do
    context "when used without chaining" do
      let(:matcher) { described_class.new(object, method) }

      it "returns failure message for without chaining" do
        expect(matcher.failure_message).to eq("expected `#{printable_block_expectation}` to delegate to `#{printable_method}` at least once, but it didn't.")
      end
    end

    context "when used with `with_arguments(*args, **kwargs, &block)`" do
      let(:matcher) { described_class.new(object, method).with_arguments(*args, **kwargs, &block) }

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      it "returns failure message for `with_arguments(*args, **kwargs, &block)`" do
        expect(matcher.failure_message).to eq("expected `#{printable_block_expectation}` to delegate to `#{printable_method}` with expected arguments at least once, but it didn't.")
      end
    end
  end

  ##
  # IMPORTANT: `failure_message_when_negated` is NOT supported yet.
  #

  describe "#with_arguments" do
    it "returns matcher" do
      expect(matcher.with_arguments).to eq(matcher)
    end
  end

  describe "#and_return_its_value" do
    it "returns matcher" do
      expect(matcher.and_return_its_value).to eq(matcher)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers

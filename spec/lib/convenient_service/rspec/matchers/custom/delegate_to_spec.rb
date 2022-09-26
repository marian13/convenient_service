# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

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
  let(:printable_block) { block_expectation.source }

  describe "#matches?" do
    context "when used without chaining" do
      let(:matcher) { described_class.new(object, method) }

      it "works" do
        ##
        # NOTE: `expect { object.foo }.to delegate_to(object, :bar)`
        #
        matcher_result
      end
    end

    context "when used with `and_return_its_value`" do
      let(:matcher) { described_class.new(object, method).and_return_its_value }

      it "works" do
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
          ##
          # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
          #
          #   def foo(...)
          #     bar(...)
          #   end
          #
          def foo(*args, **kwargs, &block)
            bar(*args, **kwargs, &block)
          end

          def bar(*args, **kwargs, &block)
            [args, kwargs, block]
          end
        end
      end

      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { proc { :foo } }

      it "works" do
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

  describe "#printable_block" do
    it "returns block_expectation source code" do
      matcher_result

      expect(matcher.printable_block).to eq(block_expectation.source)
    end
  end

  describe "#failure_message" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message).to eq("expected #{printable_block} to delegate to `#{printable_method}`")
    end
  end

  describe "#failure_message_when_negated" do
    it "returns message" do
      matcher_result

      expect(matcher.failure_message_when_negated).to eq("expected #{printable_block} NOT to delegate to `#{printable_method}`")
    end
  end

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

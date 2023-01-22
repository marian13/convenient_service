# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo do
  let(:facade) { described_class.new(matcher: matcher) }
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

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Delegate) }
  end

  example_group "instance methods" do
    describe "#matches?" do
      it "delegates to `matcher#matches?`" do
        allow(matcher).to receive(:matches?).with(block_expectation).and_call_original

        facade.matches?(block_expectation)

        expect(matcher).to have_received(:matches?).with(block_expectation)
      end

      it "returns `matcher#matches?` value" do
        expect(facade.matches?(block_expectation)).to eq(matcher.matches?(block_expectation))
      end
    end

    describe "#supports_block_expectations?" do
      it "delegates to `matcher#supports_block_expectations?`" do
        allow(matcher).to receive(:supports_block_expectations?).and_call_original

        facade.supports_block_expectations?

        expect(matcher).to have_received(:supports_block_expectations?)
      end

      it "returns `matcher#supports_block_expectations?` value" do
        expect(facade.supports_block_expectations?).to eq(matcher.supports_block_expectations?)
      end
    end

    describe "#description" do
      it "delegates to `matcher#description`" do
        allow(matcher).to receive(:description).and_call_original

        facade.description

        expect(matcher).to have_received(:description)
      end

      it "returns `matcher#description` value" do
        expect(facade.description).to eq(matcher.description)
      end
    end

    describe "#failure_message" do
      it "delegates to `matcher#failure_message`" do
        allow(matcher).to receive(:failure_message).and_call_original

        facade.failure_message

        expect(matcher).to have_received(:failure_message)
      end

      it "returns `matcher#failure_message` value" do
        expect(facade.failure_message).to eq(matcher.failure_message)
      end
    end

    describe "#failure_message_when_negated" do
      it "delegates to `matcher#failure_message_when_negated`" do
        allow(matcher).to receive(:failure_message_when_negated).and_call_original

        facade.failure_message_when_negated

        expect(matcher).to have_received(:failure_message_when_negated)
      end

      it "returns `matcher#failure_message_when_negated` value" do
        expect(facade.failure_message_when_negated).to eq(matcher.failure_message_when_negated)
      end
    end

    describe "#with_arguments" do
      let(:args) { [:foo] }
      let(:kwargs) { {foo: :bar} }
      let(:block) { -> { :foo } }

      it "delegates to `matcher#with_arguments`" do
        allow(matcher).to receive(:with_arguments).and_call_original

        facade.with_arguments(*args, **kwargs, &block)
      end

      ##
      # NOTE: You can NOT use `delegate_to` to test `delegate_to`.
      #
      it "passes `args`, `kwargs`, `block` to `matcher#with_arguments`" do
        allow(matcher).to receive(:with_arguments) { |*actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([args, kwargs, block]) }

        facade.with_arguments(*args, **kwargs, &block)
      end

      it "returns facade" do
        expect(facade.without_arguments).to eq(facade)
      end
    end

    describe "#without_arguments" do
      it "delegates to `matcher#without_arguments`" do
        allow(matcher).to receive(:without_arguments).and_call_original

        facade.without_arguments

        expect(matcher).to have_received(:without_arguments)
      end

      it "returns facade" do
        expect(facade.without_arguments).to eq(facade)
      end
    end

    describe "#and_return_its_value" do
      it "delegates to `matcher#and_return_its_value`" do
        allow(matcher).to receive(:and_return_its_value).and_call_original

        facade.and_return_its_value

        expect(matcher).to have_received(:and_return_its_value)
      end

      it "returns facade" do
        expect(facade.and_return_its_value).to eq(facade)
      end
    end

    describe "#without_calling_original" do
      it "delegates to `matcher#without_calling_original`" do
        allow(matcher).to receive(:without_calling_original).and_call_original

        facade.without_calling_original

        expect(matcher).to have_received(:without_calling_original)
      end

      it "returns facade" do
        expect(facade.without_calling_original).to eq(facade)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

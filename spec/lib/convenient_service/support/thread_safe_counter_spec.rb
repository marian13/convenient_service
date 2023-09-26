# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::ThreadSafeCounter do
  include ConvenientService::RSpec::Helpers::IgnoringException
  include ConvenientService::RSpec::Helpers::InThreads

  let(:counter) { described_class.new(initial_value: initial_value, min_value: min_value, max_value: max_value) }
  let(:initial_value) { 0 }
  let(:min_value) { -1_000_000 }
  let(:max_value) { 1_000_000 }
  let(:n) { 1_000 }

  example_group "exceptions" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    specify { expect(described_class::Exceptions::ValueAfterIncrementIsGreaterThanMaxValue).to be_descendant_of(ConvenientService::Exception) }
    specify { expect(described_class::Exceptions::ValueAfterDecrementIsLowerThanMinValue).to be_descendant_of(ConvenientService::Exception) }
  end

  example_group "attributes" do
    include ConvenientService::RSpec::PrimitiveMatchers::HaveAttrReader

    subject { counter }

    it { is_expected.to have_attr_reader(:initial_value) }
    it { is_expected.to have_attr_reader(:current_value) }
    it { is_expected.to have_attr_reader(:min_value) }
    it { is_expected.to have_attr_reader(:max_value) }
  end

  example_group "class methods" do
    describe ".new" do
      it "sets current value to initial value" do
        expect(counter.current_value).to eq(initial_value)
      end

      context "when initial value is NOT passed" do
        let(:counter) { described_class.new }

        it "defaults to `0`" do
          expect(counter.initial_value).to eq(0)
        end
      end

      context "when min value is NOT passed" do
        let(:counter) { described_class.new }

        it "defaults to `Float::Infinity`" do
          expect(counter.min_value).to eq(-Float::INFINITY)
        end
      end

      context "when max value is NOT passed" do
        let(:counter) { described_class.new }

        it "defaults to `Float::Infinity`" do
          expect(counter.max_value).to eq(Float::INFINITY)
        end
      end
    end
  end

  example_group "instance methods" do
    describe "#current_value=" do
      it "sets current value to `n`" do
        counter.current_value = n

        expect(counter.current_value).to eq(n)
      end

      it "returns `n`" do
        expect(counter.current_value = n).to eq(n)
      end

      ##
      # TODO: `@current_value = n` always returns `n` in Ruby. How to test thread-safety?
      #
    end

    describe "#increment" do
      it "increments value by `n`" do
        expect { counter.increment(n) }.to change(counter, :current_value).from(initial_value).to(initial_value + n)
      end

      it "returns current value" do
        expect(counter.increment(n)).to eq(counter.current_value)
      end

      context "when `n` is NOT passed" do
        it "increments value by `1`" do
          expect { counter.increment }.to change(counter, :current_value).from(initial_value).to(initial_value + 1)
        end
      end

      context "when current value + n is greater than max value" do
        let(:max_value) { 10 }

        it "returns current value" do
          expect(counter.increment(n)).to eq(counter.current_value)
        end

        it "does NOT changes current value" do
          expect { counter.increment(n) }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.increment }.sort).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        end
      end
    end

    describe "#increment!" do
      it "increments value by `n`" do
        expect { counter.increment!(n) }.to change(counter, :current_value).from(initial_value).to(initial_value + n)
      end

      it "returns current value" do
        expect(counter.increment!(n)).to eq(counter.current_value)
      end

      context "when `n` is NOT passed" do
        it "increments value by `1`" do
          expect { counter.increment! }.to change(counter, :current_value).from(initial_value).to(initial_value + 1)
        end
      end

      context "when current value + n is greater than max value" do
        let(:max_value) { 10 }

        let(:exception_message) do
          <<~TEXT
            Value after increment by `#{n}` is greater than the max value.

            Current value is `#{counter.current_value}`.

            Max value is `#{counter.max_value}`.
          TEXT
        end

        it "raises `ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterIncrementIsGreaterThanMaxValue`" do
          expect { counter.increment!(n) }
            .to raise_error(ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterIncrementIsGreaterThanMaxValue)
            .with_message(exception_message)
        end

        it "does NOT changes current value" do
          expect { ignoring_exception(ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterIncrementIsGreaterThanMaxValue) { counter.increment!(n) } }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.increment! }.sort).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        end
      end
    end

    describe "#bincrement" do
      it "increments value by `n`" do
        expect { counter.bincrement(n) }.to change(counter, :current_value).from(initial_value).to(initial_value + n)
      end

      it "returns `true`" do
        expect(counter.bincrement(n)).to eq(true)
      end

      context "when `n` is NOT passed" do
        it "increments value by `1`" do
          expect { counter.bincrement }.to change(counter, :current_value).from(initial_value).to(initial_value + 1)
        end
      end

      context "when current value + n is greater than max value" do
        let(:max_value) { 10 }

        it "returns `false`" do
          expect(counter.bincrement(n)).to eq(false)
        end

        it "does NOT changes current value" do
          expect { counter.bincrement(n) }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        let(:initial_value) { 5 }
        let(:max_value) { 10 }

        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.bincrement }.tally).to eq({true => 5, false => 5})
        end
      end
    end

    describe "#decrement" do
      it "decrements value by `n`" do
        expect { counter.decrement(n) }.to change(counter, :current_value).from(initial_value).to(initial_value - n)
      end

      it "returns current value" do
        expect(counter.decrement(n)).to eq(counter.current_value)
      end

      context "when `n` is NOT passed" do
        it "decrements value by `1`" do
          expect { counter.decrement }.to change(counter, :current_value).from(initial_value).to(initial_value - 1)
        end
      end

      context "when current value - n is lower than min value" do
        let(:min_value) { -10 }

        it "returns current value" do
          expect(counter.decrement(n)).to eq(counter.current_value)
        end

        it "does NOT changes current value" do
          expect { counter.decrement(n) }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.decrement }.sort).to eq([-10, -9, -8, -7, -6, -5, -4, -3, -2, -1])
        end
      end
    end

    describe "#decrement!" do
      it "decrements value by `n`" do
        expect { counter.decrement!(n) }.to change(counter, :current_value).from(initial_value).to(initial_value - n)
      end

      it "returns current value" do
        expect(counter.decrement!(n)).to eq(counter.current_value)
      end

      context "when `n` is NOT passed" do
        it "decrements value by `1`" do
          expect { counter.decrement! }.to change(counter, :current_value).from(initial_value).to(initial_value - 1)
        end
      end

      context "when current value - n is lower than min value" do
        let(:min_value) { -10 }

        let(:exception_message) do
          <<~TEXT
            Value after decrement by `#{n}` is lower than the min value.

            Current value is `#{counter.current_value}`.

            Min value is `#{counter.min_value}`.
          TEXT
        end

        it "raises `ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterDecrementIsLowerThanMinValue`" do
          expect { counter.decrement!(n) }
            .to raise_error(ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterDecrementIsLowerThanMinValue)
            .with_message(exception_message)
        end

        it "does NOT changes current value" do
          expect { ignoring_exception(ConvenientService::Support::ThreadSafeCounter::Exceptions::ValueAfterDecrementIsLowerThanMinValue) { counter.decrement!(n) } }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.decrement! }.sort).to eq([-10, -9, -8, -7, -6, -5, -4, -3, -2, -1])
        end
      end
    end

    describe "#bdecrement" do
      it "decrements value by `n`" do
        expect { counter.bdecrement(n) }.to change(counter, :current_value).from(initial_value).to(initial_value - n)
      end

      it "returns `true`" do
        expect(counter.bdecrement(n)).to eq(true)
      end

      context "when `n` is NOT passed" do
        it "decrements value by `1`" do
          expect { counter.bdecrement }.to change(counter, :current_value).from(initial_value).to(initial_value - 1)
        end
      end

      context "when current value - n is lower than min value" do
        let(:min_value) { -10 }

        it "returns `false`" do
          expect(counter.bdecrement(n)).to eq(false)
        end

        it "does NOT changes current value" do
          expect { counter.bdecrement(n) }.not_to change(counter, :current_value)
        end
      end

      example_group "thread-safety" do
        let(:initial_value) { -5 }
        let(:min_value) { -10 }

        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.bdecrement }.tally).to eq({true => 5, false => 5})
        end
      end
    end

    describe "#reset" do
      before do
        counter.increment(n)
      end

      it "resets value to initial value" do
        expect { counter.reset }.to change(counter, :current_value).from(initial_value + n).to(initial_value)
      end

      it "returns current value" do
        expect(counter.reset).to eq(counter.current_value)
      end

      example_group "thread-safety" do
        it "is thread-safe" do
          expect(in_threads(10, counter) { |counter| counter.increment && counter.reset }.uniq).to eq([0])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

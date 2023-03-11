# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::ThreadSafeCounter do
  include ConvenientService::RSpec::Helpers::InThreads

  let(:counter) { described_class.new(initial_value: initial_value, min_value: min_value, max_value: max_value) }
  let(:initial_value) { 0 }
  let(:min_value) { -1_000_000 }
  let(:max_value) { 1_000_000 }
  let(:n) { 1_000 }

  example_group "attributes" do
    include ConvenientService::RSpec::Matchers::HaveAttrReader

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
    describe "#increment!" do
      it "increments value by `n`" do
        expect { counter.increment!(n) }.to change(counter, :current_value).from(initial_value).to(initial_value + n)
      end

      it "returns current value" do
        expect(counter.increment!(n)).to eq(counter.current_value)
      end

      it "is thread-safe" do
        expect(in_threads(10, counter) { |counter| counter.increment! }.sort).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
      end

      context "when `n` is NOT passed" do
        it "increments value by `1`" do
          expect { counter.increment! }.to change(counter, :current_value).from(initial_value).to(initial_value + 1)
        end
      end

      context "when current value + n is greater than max value" do
        let(:max_value) { 10 }

        let(:error_message) do
          <<~TEXT
            Value after increment by `#{n}` is greater than the max value.

            Current value is `#{counter.current_value}`.

            Max value is `#{counter.max_value}`.
          TEXT
        end

        it "raises `ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue`" do
          expect { counter.increment!(n) }
            .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue)
            .with_message(error_message)
        end

        it "does NOT changes current value" do
          expect { counter.increment!(n, exception: false) }.not_to change(counter, :current_value)
        end

        example_group "`exception` option" do
          context "when `exception` option is NOT passed" do
            it "defaults to `true`" do
              expect { counter.increment!(n) }
                .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue)
                .with_message(error_message)
            end
          end

          context "when `exception` option is passed" do
            context "when `exception` option is `false`" do
              it "does NOT raise" do
                expect { counter.increment!(n, exception: false) }.not_to raise_error
              end
            end

            context "when `exception` option is `true`" do
              it "raises `ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue`" do
                expect { counter.increment!(n, exception: true) }
                  .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterIncrementIsGreaterThanMaxValue)
                  .with_message(error_message)
              end
            end
          end
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

      it "is thread-safe" do
        expect(in_threads(10, counter) { |counter| counter.decrement! }.sort).to eq([-10, -9, -8, -7, -6, -5, -4, -3, -2, -1])
      end

      context "when `n` is NOT passed" do
        it "decrements value by `1`" do
          expect { counter.decrement! }.to change(counter, :current_value).from(initial_value).to(initial_value - 1)
        end
      end

      context "when current value - n is lower than min value" do
        let(:min_value) { -10 }

        let(:error_message) do
          <<~TEXT
            Value after decrement by `#{n}` is lower than the min value.

            Current value is `#{counter.current_value}`.

            Min value is `#{counter.min_value}`.
          TEXT
        end

        it "raises `ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue`" do
          expect { counter.decrement!(n) }
            .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue)
            .with_message(error_message)
        end

        it "does NOT changes current value" do
          expect { counter.decrement!(n, exception: false) }.not_to change(counter, :current_value)
        end

        example_group "`exception` option" do
          context "when `exception` option is NOT passed" do
            it "defaults to `true`" do
              expect { counter.decrement!(n) }
                .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue)
                .with_message(error_message)
            end
          end

          context "when `exception` option is passed" do
            context "when `exception` option is `false`" do
              it "does NOT raise" do
                expect { counter.decrement!(n, exception: false) }.not_to raise_error
              end
            end

            context "when `exception` option is `true`" do
              it "raises `ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue`" do
                expect { counter.decrement!(n, exception: true) }
                  .to raise_error(ConvenientService::Support::ThreadSafeCounter::Errors::ValueAfterDecrementIsLowerThanMinValue)
                  .with_message(error_message)
              end
            end
          end
        end
      end
    end

    describe "#reset!" do
      before do
        counter.increment!(n)
      end

      it "resets value to initial value" do
        expect { counter.reset! }.to change(counter, :current_value).from(initial_value + n).to(initial_value)
      end

      it "returns current value" do
        expect(counter.reset!).to eq(counter.current_value)
      end

      it "is thread-safe" do
        expect(in_threads(10, counter) { |counter| counter.increment! && counter.reset! }.uniq).to eq([0])
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

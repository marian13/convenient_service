# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array, type: :standard do
  describe ".contain_exactly?" do
    let(:first_array) { [1, 2, 3] }
    let(:second_array) { [2, 3, 1] }

    describe ".memoize_including_falsy_values" do
      let(:object) { Object.new }
      let(:ivar_name) { :@foo }
      let(:value_block) { proc { false } }

      ##
      # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
      #
      # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
      it "delegates to `ConvenientService::Utils::Array::ContainExactly.call`" do
        expect(described_class::ContainExactly)
          .to receive(:call)
            .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
              expect([actual_args, actual_kwargs, actual_block]).to eq([[first_array, second_array], {}, nil])

              original.call(*actual_args, **actual_kwargs, &actual_block)
            }

        described_class.contain_exactly?(first_array, second_array)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

      it "returns `ConvenientService::Utils::Array::ContainExactly.call` value" do
        expect(described_class.contain_exactly?(first_array, second_array)).to eq(described_class::ContainExactly.call(first_array, second_array))
      end
    end
  end

  describe ".drop_while" do
    let(:array) { [1, 2, 3, 4, 5].freeze }
    let(:inclusively) { true }
    let(:condition_block) { proc { |item| item != 3 } }

    ##
    # HACK: RSpec passes `array.first` as `_original` when `inclusively` kwargs is passed. That is why `inclusively` is skipped here. But its usage is still verified by the `returns` spec.
    #
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::DropWhile.call`" do
      expect(described_class::DropWhile)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array], {}, condition_block])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.drop_while(array, &condition_block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::DropWhile.call` value" do
      expect(described_class.drop_while(array, inclusively: inclusively, &condition_block)).to eq(described_class::DropWhile.call(array, inclusively: inclusively, &condition_block))
    end
  end

  describe ".find_yield" do
    let(:array) { ["foo bar"] }
    let(:block) { proc { |item| item.match(/\w+/) } }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::FindYield.call`" do
      expect(described_class::FindYield)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array], {}, block])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.find_yield(array, &block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::FindYield.call` value" do
      expect(described_class.find_yield(array, &block)).to eq(described_class::FindYield.call(array, &block))
    end
  end

  describe ".find_last" do
    let(:array) { ["foo"] }
    let(:block) { proc { |item| item[0] == "b" } }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::FindLast.call`" do
      expect(described_class::FindLast)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array], {}, block])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.find_last(array, &block)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::FindLast.call` value" do
      expect(described_class.find_last(array, &block)).to eq(described_class::FindLast.call(array, &block))
    end
  end

  describe ".keep_after" do
    let(:array) { [:foo, :bar, :baz] }
    let(:object) { :bar }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::KeepAfter.call`" do
      expect(described_class::KeepAfter)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array, object], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.keep_after(array, object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::KeepAfter.call` value" do
      expect(described_class.keep_after(array, object)).to eq(described_class::KeepAfter.call(array, object))
    end
  end

  describe ".limited_push" do
    let(:array) { [:foo, :bar] }
    let(:object) { :baz }
    let(:limit) { 10 }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::LimitedPush.call`" do
      expect(described_class::LimitedPush)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array, object], {limit: limit}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.limited_push(array, object, limit: limit)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::LimitedPush.call` value" do
      expect(described_class.limited_push(array, object, limit: limit)).to eq(described_class::LimitedPush.call(array, object, limit: limit))
    end
  end

  describe ".merge" do
    let(:array) { [:a, :b, :c] }
    let(:overrides) { {0 => :foo} }
    let(:raise_on_non_integer_index) { true }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::Merge.call`" do
      expect(described_class::Merge)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array, overrides], {raise_on_non_integer_index: raise_on_non_integer_index}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.merge(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::Merge.call` value" do
      expect(described_class.merge(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index)).to eq(described_class::Merge.call(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index))
    end
  end

  describe ".rjust" do
    let(:array) { [:a, :b, :c] }
    let(:size) { 1 }
    let(:pad) { :x }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::Rjust.call`" do
      expect(described_class::Rjust)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[array, size, pad], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.rjust(array, size, pad)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::Rjust.call` value" do
      expect(described_class.rjust(array, size, pad)).to eq(described_class::Rjust.call(array, size, pad))
    end
  end

  describe ".wrap" do
    let(:object) { 42 }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength
    it "delegates to `ConvenientService::Utils::Array::Wrap.call`" do
      expect(described_class::Wrap)
        .to receive(:call)
          .and_wrap_original { |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[object], {}, nil])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          }

      described_class.wrap(object)
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies, RSpec/ExampleLength

    it "returns `ConvenientService::Utils::Array::Wrap.call` value" do
      expect(described_class.wrap(object)).to eq(described_class::Wrap.call(object))
    end
  end
end

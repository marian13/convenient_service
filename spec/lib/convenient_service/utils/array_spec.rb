# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Utils::Array do
  include ConvenientService::RSpec::Matchers::DelegateTo

  describe ".contain_exactly?" do
    let(:first_array) { [1, 2, 3] }
    let(:second_array) { [2, 3, 1] }

    specify do
      expect { described_class.contain_exactly?(first_array, second_array) }
        .to delegate_to(ConvenientService::Utils::Array::ContainExactly, :call)
        .with_arguments(first_array, second_array)
        .and_return_its_value
    end
  end

  describe ".drop_while" do
    let(:array) { [1, 2, 3, 4, 5] }
    let(:condition_block) { proc { |item| item != 3 } }
    let(:inclusively) { true }

    specify do
      expect { described_class.drop_while(array, &condition_block) }
        .to delegate_to(ConvenientService::Utils::Array::DropWhile, :call)
        .with_arguments(array, &condition_block)
        .and_return_its_value
    end
  end

  describe ".find_yield" do
    let(:array) { ["foo bar"] }
    let(:block) { proc { |item| item.match(/\w+/) } }

    specify do
      expect { described_class.find_yield(array, &block) }
        .to delegate_to(ConvenientService::Utils::Array::FindYield, :call)
        .with_arguments(array, &block)
        .and_return_its_value
    end
  end

  describe ".find_last" do
    let(:array) { ["foo"] }
    let(:block) { proc { |item| item[0] == "b" } }

    specify do
      expect { described_class.find_last(array, &block) }
        .to delegate_to(ConvenientService::Utils::Array::FindLast, :call)
        .with_arguments(array, &block)
        .and_return_its_value
    end
  end

  describe ".keep_after" do
    let(:array) { [:foo, :bar, :baz] }
    let(:object) { :bar }

    specify do
      expect { described_class.keep_after(array, object) }
        .to delegate_to(ConvenientService::Utils::Array::KeepAfter, :call)
        .with_arguments(array, object)
        .and_return_its_value
    end
  end

  describe ".limited_push" do
    let(:array) { [:foo, :bar] }
    let(:object) { :baz }
    let(:limit) { 10 }

    specify do
      expect { described_class.limited_push(array, object, limit: limit) }
        .to delegate_to(ConvenientService::Utils::Array::LimitedPush, :call)
        .with_arguments(array, object, limit: limit)
        .and_return_its_value
    end
  end

  describe ".merge" do
    let(:array) { [:a, :b, :c] }
    let(:overrides) { {0 => :foo} }
    let(:raise_on_non_integer_index) { true }

    specify do
      expect { described_class.merge(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index) }
        .to delegate_to(ConvenientService::Utils::Array::Merge, :call)
        .with_arguments(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index)
        .and_return_its_value
    end
  end

  describe ".rjust" do
    let(:array) { [:a, :b, :c] }
    let(:size) { 1 }
    let(:pad) { :x }

    specify do
      expect { described_class.rjust(array, size, pad) }
        .to delegate_to(ConvenientService::Utils::Array::Rjust, :call)
        .with_arguments(array, size, pad)
        .and_return_its_value
    end
  end

  describe ".wrap" do
    let(:object) { 42 }

    specify do
      expect { described_class.wrap(object) }
        .to delegate_to(ConvenientService::Utils::Array::Wrap, :call)
        .with_arguments(object)
        .and_return_its_value
    end
  end
end

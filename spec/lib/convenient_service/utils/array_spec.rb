# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array do
  describe ".contain_exactly?" do
    subject(:result) { described_class.contain_exactly?(first_array, second_array) }

    context "when `first_array' contains same elements as `second_array'" do
      context "when those elements do NOT have same positions" do
        let(:first_array) { [1, 2, 3] }
        let(:second_array) { [2, 3, 1] }

        it "returns true" do
          expect(result).to eq(true)
        end
      end

      context "when those elements have same positions" do
        let(:first_array) { [1, 2, 3] }
        let(:second_array) { [1, 2, 3] }

        it "returns true" do
          expect(result).to eq(true)
        end
      end

      context "when `first_array' contains duplicates" do
        context "when `second_array` does NOT contain same amount of duplicates" do
          let(:first_array) { [1, 1, 2, 2] }
          let(:second_array) { [1, 1, 2, 3] }

          it "returns false" do
            expect(result).to eq(false)
          end
        end

        context "when `second_array` contains same amount of duplicates" do
          let(:first_array) { [1, 1, 2, 2] }
          let(:second_array) { [1, 1, 2, 2] }

          it "returns true" do
            expect(result).to eq(true)
          end
        end
      end
    end

    context "when `first_array' contains different elements comparing to `second_array'" do
      let(:first_array) { [1, 2, 3] }
      let(:second_array) { [2, 3, 4] }

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when arrays contain custom class objects as values" do
      let(:first_array) { [klass.new(1), klass.new(2), klass.new(3)] }
      let(:second_array) { [klass.new(1), klass.new(2), klass.new(3)] }

      context "when that class does NOT implement `hash' and `eql?' instance methods" do
        let(:klass) do
          Class.new do
            attr_reader :value

            def initialize(value)
              @value = value
            end

            def ==(other)
              value == other.value
            end
          end
        end

        it "returns false" do
          expect(result).to eq(false)
        end
      end

      context "when that class implements `hash' and `eql?' instance methods" do
        let(:klass) do
          Class.new do
            attr_reader :value

            def initialize(value)
              @value = value
            end

            def ==(other)
              value == other.value
            end

            # rubocop:disable Rails/Delegate
            def hash
              value.hash
            end
            # rubocop:enable Rails/Delegate

            def eql?(other)
              hash == other.hash
            end
          end
        end

        it "returns true" do
          expect(result).to eq(true)
        end
      end
    end
  end

  describe ".find_last" do
    subject(:result) { described_class.find_last(array) { |item| item[0] == "b" } }

    context "when array does NOT contain item to find" do
      let(:array) { ["foo"] }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when array contains one item to find" do
      let(:array) { ["foo", "bar"] }

      it "returns that item" do
        expect(result).to eq("bar")
      end
    end

    context "when array contains multiple items to find" do
      let(:array) { ["foo", "bar", "baz"] }

      it "returns last from those items" do
        expect(result).to eq("baz")
      end
    end
  end

  describe ".merge" do
    subject(:result) { described_class.merge(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index) }

    let(:array) { [:a, :b, :c] }
    let(:raise_on_non_integer_index) { true }

    context "when `overrides' is NOT empty" do
      context "when `overrides' contains one `index/value' pair" do
        let(:overrides) { {0 => :foo} }

        it "sets `value' by `index' in `array' for that pair" do
          expect(result).to eq([:foo, :b, :c])
        end

        it "returns `array' copy" do
          expect(result.object_id).not_to eq(array.object_id)
        end
      end

      context "when `overrides' contains multiple index/value pairs" do
        let(:overrides) { {0 => :foo, 1 => :bar} }

        it "sets `value' by `index' in `array' for those pairs" do
          expect(result).to eq([:foo, :bar, :c])
        end

        it "returns `array' copy" do
          expect(result.object_id).not_to eq(array.object_id)
        end
      end

      context "when `overrides' contains non integer keys" do
        let(:overrides) { {:a => :foo, 1 => :bar} }

        let(:error_message) do
          <<~TEXT
            Index `:a' is NOT an integer.
          TEXT
        end

        context "when `raise_on_non_integer_index' is `false'" do
          let(:raise_on_non_integer_index) { false }

          it "skips those non integer keys" do
            expect(result).to eq([:a, :bar, :c])
          end
        end

        context "when `raise_on_non_integer_index' is `true'" do
          let(:raise_on_non_integer_index) { true }

          it "raises `ConvenientService::Utils::Array::Errors::NonIntegerIndex'" do
            expect { result }
              .to raise_error(ConvenientService::Utils::Array::Errors::NonIntegerIndex)
              .with_message(error_message)
          end
        end

        context "when `raise_on_non_integer_index' is NOT passed" do
          subject(:result) { described_class.merge(array, overrides) }

          it "raises `ConvenientService::Utils::Array::Errors::NonIntegerIndex'" do
            expect { result }
              .to raise_error(ConvenientService::Utils::Array::Errors::NonIntegerIndex)
              .with_message(error_message)
          end
        end
      end
    end

    context "when `overrides' is empty" do
      let(:overrides) { {} }

      it "returns `array' copy" do
        expect(result.object_id).not_to eq(array.object_id)
      end
    end
  end

  describe ".rjust" do
    subject(:result) { described_class.rjust(array, size, pad) }

    let(:array) { [:a, :b, :c] }
    let(:pad) { :x }

    context "when `array' size is lower than `size'" do
      let(:size) { 1 }

      it "returns `array'" do
        expect(result).to eq(array)
      end
    end

    context "when `array' size is equal to `size'" do
      let(:size) { 3 }

      it "returns `array'" do
        expect(result).to eq(array)
      end
    end

    context "when `array' size is greater than `size'" do
      let(:size) { 10 }

      it "returns `array' with `size' with `pad' for added items" do
        expect(result).to eq([:a, :b, :c, :x, :x, :x, :x, :x, :x, :x])
      end

      context "when pad is NOT passed" do
        subject(:result) { described_class.rjust(array, size) }

        it "returns `array' with `size' with `nil' for added items" do
          expect(result).to eq([:a, :b, :c, nil, nil, nil, nil, nil, nil, nil])
        end
      end
    end
  end

  describe ".wrap" do
    subject(:result) { described_class.wrap(object) }

    context "when object is `nil'" do
      let(:object) { nil }

      it "returns empty array" do
        expect(result).to eq([])
      end
    end

    context "when object responds to `to_ary'" do
      let(:object) { OpenStruct.new(to_ary: value) }

      context "when `to_ary' returns falsey value" do
        let(:value) { nil }

        it "returns object inside array" do
          expect(result).to eq([object])
        end
      end

      context "when `to_ary' returns truthy value" do
        let(:value) { [1, 2, 3] }

        it "returns that truthy value" do
          expect(result).to eq(value)
        end
      end
    end

    context "when object is NEITHER nil NOR responds to `to_ary'" do
      let(:object) { "string" }

      it "returns object inside array" do
        expect(result).to eq([object])
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

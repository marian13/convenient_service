# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::ContainExactly, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(first_array, second_array) }

    context "when `first_array` contains same elements as `second_array`" do
      context "when those elements do NOT have same positions" do
        let(:first_array) { [1, 2, 3] }
        let(:second_array) { [2, 3, 1] }

        it "returns true" do
          expect(util_result).to eq(true)
        end
      end

      context "when those elements have same positions" do
        let(:first_array) { [1, 2, 3] }
        let(:second_array) { [1, 2, 3] }

        it "returns true" do
          expect(util_result).to eq(true)
        end
      end

      context "when `first_array` contains duplicates" do
        context "when `second_array` does NOT contain same amount of duplicates" do
          let(:first_array) { [1, 1, 2, 2] }
          let(:second_array) { [1, 1, 2, 3] }

          it "returns false" do
            expect(util_result).to eq(false)
          end
        end

        context "when `second_array` contains same amount of duplicates" do
          let(:first_array) { [1, 1, 2, 2] }
          let(:second_array) { [1, 1, 2, 2] }

          it "returns true" do
            expect(util_result).to eq(true)
          end
        end
      end
    end

    context "when `first_array` contains different elements comparing to `second_array`" do
      let(:first_array) { [1, 2, 3] }
      let(:second_array) { [2, 3, 4] }

      it "returns false" do
        expect(util_result).to eq(false)
      end
    end

    context "when arrays contain custom class objects as values" do
      let(:first_array) { [klass.new(1), klass.new(2), klass.new(3)] }
      let(:second_array) { [klass.new(1), klass.new(2), klass.new(3)] }

      context "when that class does NOT implement `hash` and `eql?` instance methods" do
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
          expect(util_result).to eq(false)
        end
      end

      context "when that class implements `hash` and `eql?` instance methods" do
        let(:klass) do
          Class.new do
            attr_reader :value

            def initialize(value)
              @value = value
            end

            def ==(other)
              value == other.value
            end

            def hash
              [self.class, value].hash
            end

            def eql?(other)
              value == other.value
            end
          end
        end

        it "returns true" do
          expect(util_result).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

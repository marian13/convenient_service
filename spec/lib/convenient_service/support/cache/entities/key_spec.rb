# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Support::Cache::Entities::Key, type: :standard do
  let(:args) { [:foo] }
  let(:kwargs) { {foo: :bar} }
  let(:block) { proc { :foo } }
  let(:key) { described_class.new(*args, **kwargs, &block) }

  example_group "instance methods" do
    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(key == other).to be_nil
        end
      end

      context "when `other` has different `args`" do
        let(:other) { described_class.new(:baz, **kwargs, &block) }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end
      end

      context "when `other` has different `kwargs`" do
        let(:other) { described_class.new(*args, baz: :qux, &block) }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end
      end

      context "when `other` has different `block`" do
        let(:other) { described_class.new(*args, **kwargs, &other_block) }
        let(:other_block) { proc { :baz } }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end

        ##
        # TODO: Refactor.
        #
        # rubocop:disable Lint/Void, RSpec/ExampleLength
        it "uses `source_location` to compare blocks" do
          constructor_arguments_source_location = double
          other_block_source_location = double

          allow(block).to receive(:source_location).and_return(constructor_arguments_source_location)
          allow(other_block).to receive(:source_location).and_return(other_block_source_location)
          allow(constructor_arguments_source_location).to receive(:==).with(other_block_source_location)

          key == other

          expect(constructor_arguments_source_location).to have_received(:==)
        end
        # rubocop:enable Lint/Void, RSpec/ExampleLength
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(key == other).to eq(true)
        end
      end
    end

    describe "#eql?" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `false`" do
          expect(key == other).to be_nil
        end
      end

      context "when keys have different hashes" do
        let(:other) { described_class.new(:step, **kwargs, &block) }

        it "returns `false`" do
          expect(key == other).to eq(false)
        end
      end

      context "when keys have same hashes" do
        let(:other) { described_class.new(*args, **kwargs, &block) }

        it "returns `true`" do
          expect(key == other).to eq(true)
        end
      end
    end

    describe "#hash" do
      it "returns hash based on `args`, `kwargs`, and `block` source location" do
        expect(key.hash).to eq([args, kwargs, block.source_location].hash)
      end

      context "when `block` in `nil`" do
        let(:block) { nil }

        it "uses `nil` hash for `block`" do
          expect(key.hash).to eq([args, kwargs, nil].hash)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

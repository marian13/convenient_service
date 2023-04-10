# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Hash do
  example_group "class methods" do
    describe ".new" do
      context "when `hash` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to empty hash" do
          expect(cache.store).to eq({})
        end
      end
    end
  end

  example_group "instance methods" do
    let(:cache) { described_class.new }

    describe "#store" do
      let(:cache) { described_class.new(hash) }
      let(:hash) { {foo: :bar} }

      it "returns hash that is used as store internally" do
        expect(cache.store).to equal(hash)
      end
    end

    describe "#empty?" do
      context "when cache has NO keys" do
        before do
          cache.clear
        end

        it "returns `true`" do
          expect(cache.empty?).to eq(true)
        end
      end

      context "when cache has at least one key" do
        before do
          cache[:foo] = :bar
        end

        it "returns `false`" do
          expect(cache.empty?).to eq(false)
        end
      end
    end

    describe "#exist?" do
      let(:key) { :foo }
      let(:value) { :foo }

      context "when cache does NOT have `key`" do
        before do
          cache.clear
        end

        it "returns `false`" do
          expect(cache.exist?(key)).to eq(false)
        end
      end

      context "when cache has `key`" do
        before do
          cache[key] = value
        end

        it "returns `true`" do
          expect(cache.exist?(key)).to eq(true)
        end
      end
    end

    describe "#read" do
      let(:key) { :foo }
      let(:value) { :foo }

      context "when cache does NOT have `key`" do
        before do
          cache.clear
        end

        it "returns `nil`" do
          expect(cache.read(key)).to eq(nil)
        end
      end

      context "when cache has `key`" do
        before do
          cache[key] = value
        end

        it "returns `value` by that `key`" do
          expect(cache.read(key)).to eq(value)
        end
      end
    end

    describe "#write" do
      let(:key) { :foo }
      let(:value) { :foo }

      context "when cache does NOT have `key`" do
        before do
          cache.clear
        end

        it "returns `value`" do
          expect(cache.write(key, value)).to eq(value)
        end

        it "stores `value` by `key`" do
          cache.write(key, value)

          expect(cache.read(key)).to eq(value)
        end
      end

      context "when cache has `key`" do
        before do
          cache[key] = value
        end

        it "returns `value` by that `key`" do
          expect(cache.write(key, value)).to eq(value)
        end

        it "updates `value` by `key`" do
          cache.write(key, :bar)

          expect(cache.read(key)).to eq(:bar)
        end
      end
    end

    describe "#delete" do
      let(:key) { :foo }
      let(:value) { :foo }

      context "when cache does NOT have `key`" do
        before do
          cache.clear
        end

        it "returns `nil`" do
          expect(cache.delete(key)).to be_nil
        end
      end

      context "when cache has `key`" do
        before do
          cache[key] = value
        end

        it "returns `value` by that `key`" do
          expect(cache.delete(key)).to eq(value)
        end

        it "removes `value` by `key`" do
          cache.delete(key)

          expect(cache.read(key)).to be_nil
        end
      end
    end

    describe "#clear" do
      context "when cache has NO keys" do
        it "returns cache" do
          expect(cache.clear).to eq(cache)
        end
      end

      context "when cache has any keys" do
        before do
          cache[:foo] = :bar
        end

        it "returns `cache`" do
          expect(cache.clear).to eq(cache)
        end

        it "removes those keys from cache" do
          expect { cache.clear }.to change(cache, :empty?).from(false).to(true)
        end
      end
    end

    describe "#scope" do
      include ConvenientService::RSpec::Matchers::CacheItsValue

      it "returns sub cache" do
        expect(cache.scope(:foo)).to eq(described_class.new)
      end

      specify do
        expect { cache.scope(:foo) }.to cache_its_value
      end

      context "when nested" do
        it "returns sub cache" do
          expect(cache.scope(:foo).scope(:bar)).to eq(described_class.new)
        end

        specify do
          expect { cache.scope(:foo).scope(:bar) }.to cache_its_value
        end
      end
    end

    example_group "comparison" do
      let(:cache) { described_class.new }

      describe "#==" do
        context "when caches have different classes" do
          let(:other) { 42 }

          it "returns `nil`" do
            expect(cache == other).to eq(nil)
          end
        end

        context "when caches have different arrays" do
          let(:other) { described_class.new([:bar]) }

          it "returns `true`" do
            expect(cache == other).to eq(false)
          end
        end

        context "when caches have same attributes" do
          let(:other) { described_class.new }

          it "returns `true`" do
            expect(cache == other).to eq(true)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Array, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Support::Cache::Entities::Caches::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `store` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to empty array" do
          expect(cache.store).to eq([])
        end
      end

      context "when `store` is passed" do
        let(:cache) { described_class.new(store: [].freeze) }

        it "is NOT mutated" do
          expect { cache.store }.not_to raise_error
        end
      end

      context "when `default` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.default).to be_nil
        end
      end

      context "when `default` is passed" do
        context "when `cache` has missing key" do
          let(:cache) { described_class.new(default: default_value) }
          let(:default_value) { 42 }

          it "modifies `read` to return `default` value" do
            expect(cache.read(:missing_key)).to eq(default_value)
          end

          it "modifies `fetch` without block to return `default` value" do
            expect(cache.fetch(:missing_key)).to eq(default_value)
          end
        end
      end

      context "when `parent` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.parent).to be_nil
        end
      end

      context "when `key` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to `nil`" do
          expect(cache.key).to be_nil
        end
      end
    end
  end

  example_group "instance methods" do
    let(:cache) { described_class.new }

    describe "#backend" do
      let(:cache) { described_class.new }

      it "returns `ConvenientService::Support::Cache::Constants::Backends::ARRAY`" do
        expect(cache.backend).to eq(ConvenientService::Support::Cache::Constants::Backends::ARRAY)
      end
    end

    describe "#store" do
      context "when store is NOT empty" do
        let(:cache) { described_class.new }

        before do
          cache.set(:foo, :bar)
        end

        it "returns underlying array" do
          expect(cache.store).to eq([ConvenientService::Support::Cache::Entities::Caches::Array::Entities::Pair.new(key: :foo, value: :bar)])
        end
      end

      context "when store is empty" do
        let(:cache) { described_class.new }

        it "returns empty array" do
          expect(cache.store).to eq([])
        end
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

      context "when `cache` does NOT have `key`" do
        before do
          cache.clear
        end

        context "when `cache` does NOT have `default` value" do
          it "returns `nil`" do
            expect(cache.read(key)).to eq(nil)
          end
        end

        context "when `cache` has `default` value" do
          let(:default_value) { 42 }

          before do
            cache.default = default_value
          end

          it "returns `default` value" do
            expect(cache.read(key)).to eq(default_value)
          end
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

        context "when cache is sub cache" do
          let(:scoped_cache) { cache.scope(:bar) }

          it "saves sub cache as scope in parent cache" do
            expect { scoped_cache.write(key, value) }.to change { cache.read(:bar) }.from(nil).to(scoped_cache)
          end
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

        context "when cache is sub cache" do
          let(:scoped_cache) { cache.scope(:bar) }

          it "saves sub cache as scope in parent cache" do
            expect { scoped_cache.write(key, value) }.to change { cache.read(:bar) }.from(nil).to(scoped_cache)
          end
        end
      end
    end

    describe "#fetch" do
      let(:key) { :foo }
      let(:value) { :bar }

      context "when `block` is NOT passed" do
        context "when `cache` does NOT have `key`" do
          before do
            cache.clear
          end

          context "when `cache` does have `default` value" do
            it "returns `nil`" do
              expect(cache.fetch(key)).to be_nil
            end
          end

          context "when `cache` has `default` value" do
            let(:default_value) { 42 }

            before do
              cache.default = default_value
            end

            it "returns `default` value" do
              expect(cache.fetch(key)).to eq(default_value)
            end
          end
        end

        context "when `cache` has `key`" do
          before do
            cache[key] = value
          end

          it "returns `value`" do
            expect(cache.fetch(key)).to eq(value)
          end
        end
      end

      context "when `block` is passed" do
        let(:block) { proc { value } }

        context "when `cache` does NOT have `key`" do
          before do
            cache.clear
          end

          it "returns `value`" do
            expect(cache.fetch(key, &block)).to eq(value)
          end

          it "stores `value` by `key`" do
            cache.fetch(key, &block)

            expect(cache.read(key)).to eq(value)
          end

          context "when cache is sub cache" do
            let(:scoped_cache) { cache.scope(:bar) }

            it "saves sub cache as scope in parent cache" do
              expect { scoped_cache.fetch(key, &block) }.to change { cache.read(:bar) }.from(nil).to(scoped_cache)
            end
          end
        end

        context "when `cache` has `key`" do
          before do
            cache[key] = value
          end

          it "returns `value` by that `key`" do
            expect(cache.fetch(key, &block)).to eq(value)
          end

          it "does NOT update `value` by `key`" do
            cache.fetch(key) { :baz }

            expect(cache.read(key)).to eq(value)
          end
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

      context "when cache is sub cache" do
        let(:scoped_cache) { cache.scope(:foo) }

        context "when `key` is NOT last sub cache key" do
          before do
            scoped_cache[:bar] = :bar
            scoped_cache[:baz] = :baz
          end

          it "does NOT delete sub cache as scope in parent cache" do
            expect { scoped_cache.delete(:bar) }.not_to change { cache.read(:foo) }.from(scoped_cache)
          end
        end

        context "when `key` is last sub cache key" do
          before do
            scoped_cache[:bar] = :bar
          end

          it "deletes sub cache as scope in parent cache" do
            expect { scoped_cache.delete(:bar) }.to change { cache.read(:foo) }.from(scoped_cache).to(nil)
          end
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

    describe "#[]" do
      let(:key) { :foo }

      specify do
        expect { cache[key] }
          .to delegate_to(cache, :read)
          .with_arguments(key)
          .and_return_its_value
      end
    end

    describe "#get" do
      let(:key) { :foo }

      specify do
        expect { cache.get(key) }
          .to delegate_to(cache, :read)
          .with_arguments(key)
          .and_return_its_value
      end
    end

    describe "#[]=" do
      let(:key) { :foo }
      let(:value) { :foo }

      specify do
        expect { cache[key] = value }
          .to delegate_to(cache, :write)
          .with_arguments(key, value)
          .and_return_its_value
      end
    end

    describe "#set=" do
      let(:key) { :foo }
      let(:value) { :foo }

      specify do
        expect { cache.set(key, value) }
          .to delegate_to(cache, :write)
          .with_arguments(key, value)
          .and_return_its_value
      end
    end

    describe "#scope" do
      include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

      it "returns sub cache" do
        expect(cache.scope(:foo)).to eq(described_class.new)
      end

      context "when NO values were written to sub cache" do
        specify do
          expect { cache.scope(:foo) }.not_to cache_its_value
        end
      end

      context "when any value was written to sub cache" do
        before do
          cache.scope(:foo)[:bar] = :baz
        end

        specify do
          expect { cache.scope(:foo) }.to cache_its_value
        end
      end

      context "when nested" do
        it "returns nested sub cache" do
          expect(cache.scope(:foo).scope(:bar)).to eq(described_class.new)
        end

        context "when NO values were written to nested sub cache" do
          specify do
            expect { cache.scope(:foo).scope(:bar) }.not_to cache_its_value
          end
        end

        context "when any value was written to nested sub cache" do
          before do
            cache.scope(:foo).scope(:bar)[:baz] = :qux
          end

          specify do
            expect { cache.scope(:foo).scope(:bar) }.to cache_its_value
          end
        end
      end

      example_group "`backed_by` option" do
        context "when `backed_by` option is NOT passed" do
          context "when cache does NOT sub cache by scope" do
            it "returns sub cache backed by cache backend" do
              expect(cache.scope(:foo).backend).to eq(cache.backend)
            end
          end

          context "when cache already has sub cache by scope" do
            before do
              cache.scope(:foo).write(:bar, :baz)
            end

            it "returns sub cache backed by cache backend" do
              expect(cache.scope(:foo).backend).to eq(cache.backend)
            end
          end
        end

        context "when `backed_by` option is passed" do
          context "when cache does NOT sub cache by scope" do
            it "returns sub cache backed by `backed_by` option backend" do
              expect(cache.scope(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::HASH).backend).to eq(ConvenientService::Support::Cache::Constants::Backends::HASH)
            end
          end

          context "when cache already has sub cache by scope" do
            before do
              cache.scope(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY).write(:bar, :baz)
            end

            it "returns sub cache with already set backend ignoring `backed_by` option" do
              expect(cache.scope(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::HASH).backend).to eq(ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY)
            end
          end
        end
      end
    end

    describe "#scope!" do
      include ConvenientService::RSpec::PrimitiveMatchers::CacheItsValue

      it "returns sub cache" do
        expect(cache.scope!(:foo)).to eq(described_class.new)
      end

      context "when NO values were written to sub cache" do
        specify do
          expect { cache.scope!(:foo) }.to cache_its_value
        end
      end

      context "when any value was written to sub cache" do
        before do
          cache.scope!(:foo)[:bar] = :baz
        end

        specify do
          expect { cache.scope!(:foo) }.to cache_its_value
        end
      end

      context "when nested" do
        it "returns nested sub cache" do
          expect(cache.scope!(:foo).scope!(:bar)).to eq(described_class.new)
        end

        context "when NO values were written to nested sub cache" do
          specify do
            expect { cache.scope!(:foo).scope!(:bar) }.to cache_its_value
          end
        end

        context "when any value was written to nested sub cache" do
          before do
            cache.scope!(:foo).scope!(:bar)[:baz] = :qux
          end

          specify do
            expect { cache.scope!(:foo).scope!(:bar) }.to cache_its_value
          end
        end
      end

      example_group "`backed_by` option" do
        context "when `backed_by` option is NOT passed" do
          context "when cache does NOT sub cache by scope" do
            it "returns sub cache backed by cache backend" do
              expect(cache.scope!(:foo).backend).to eq(cache.backend)
            end
          end

          context "when cache already has sub cache by scope" do
            before do
              cache.scope!(:foo).write(:bar, :baz)
            end

            it "returns sub cache backed by cache backend" do
              expect(cache.scope!(:foo).backend).to eq(cache.backend)
            end
          end
        end

        context "when `backed_by` option is passed" do
          context "when cache does NOT sub cache by scope" do
            it "returns sub cache backed by `backed_by` option backend" do
              expect(cache.scope!(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::HASH).backend).to eq(ConvenientService::Support::Cache::Constants::Backends::HASH)
            end
          end

          context "when cache already has sub cache by scope" do
            before do
              cache.scope!(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY).write(:bar, :baz)
            end

            it "returns sub cache with already set backend ignoring `backed_by` option" do
              expect(cache.scope!(:foo, backed_by: ConvenientService::Support::Cache::Constants::Backends::HASH).backend).to eq(ConvenientService::Support::Cache::Constants::Backends::THREAD_SAFE_ARRAY)
            end
          end
        end
      end
    end

    describe "#default=" do
      let(:default_value) { 42 }

      context "when `cache` is NOT scoped cache" do
        let(:cache) { described_class.new }

        it "sets `default` value" do
          cache.default = default_value

          expect(cache.default).to eq(default_value)
        end

        it "returns `default` value" do
          expect(cache.default = default_value).to eq(default_value)
        end
      end

      context "when `cache` is scoped cache" do
        let(:cache) { described_class.new }

        let(:scoped_cache) { cache.scope(:foo) }

        it "sets `default` value" do
          scoped_cache.default = default_value

          expect(scoped_cache.default).to eq(default_value)
        end

        it "returns `default` value" do
          expect(scoped_cache.default = default_value).to eq(default_value)
        end

        it "saves scoped cached in parent cache" do
          expect { scoped_cache.default = default_value }.to change { cache.exist?(:foo) }.from(false).to(true)
        end
      end

      context "when `cache` includes scoped caches" do
        let(:cache) { described_class.new }

        before do
          cache.scope!(:foo).default = :bar
        end

        it "does NOT set `default` value of included scoped caches" do
          expect { cache.default = default_value }.not_to change { cache.scope!(:foo).default }.from(:bar)
        end
      end

      context "when `cache` has missing key" do
        let(:cache) { described_class.new }

        before do
          cache.default = default_value
        end

        it "modifies `read` to return `default` value" do
          expect(cache.read(:missing_key)).to eq(default_value)
        end

        it "modifies `fetch` without block to return `default` value" do
          expect(cache.fetch(:missing_key)).to eq(default_value)
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
          let(:other) { described_class.new(store: [:bar]) }

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

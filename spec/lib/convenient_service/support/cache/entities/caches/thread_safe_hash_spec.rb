# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::ThreadSafeHash, type: :standard do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "inheritance" do
    include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

    subject { described_class }

    it { is_expected.to be_descendant_of(ConvenientService::Support::Cache::Entities::Caches::Base) }
  end

  example_group "class methods" do
    describe ".new" do
      context "when `hash` is NOT passed" do
        let(:cache) { described_class.new }

        it "defaults to empty hash" do
          expect(cache.store).to eq({})
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

    describe "#store" do
      let(:cache) { described_class.new(store: hash) }
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
    end

    describe "#fetch" do
      let(:key) { :foo }
      let(:value) { :bar }

      context "when `block` is NOT passed" do
        context "when cache does NOT have `key`" do
          before do
            cache.clear
          end

          it "returns `nil`" do
            expect(cache.fetch(key)).to be_nil
          end
        end

        context "when cache has `key`" do
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

        context "when cache does NOT have `key`" do
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

        context "when cache has `key`" do
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

      ##
      # TODO: Direct thread-safety spec.
      #
      # example_group "thread-safety" do
      #   it "is thread-safe" do
      #   end
      # end
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

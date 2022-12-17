# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache do
  example_group "instance methods" do
    let(:cache) { described_class.new }

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

        it "returns cache" do
          expect(cache.clear).to eq(cache)
        end

        it "remove those keys from cache" do
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
  end
end
# rubocop:enable RSpec/NestedGroups

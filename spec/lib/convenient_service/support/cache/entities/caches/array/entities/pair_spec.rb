# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Cache::Entities::Caches::Array::Entities::Pair, type: :standard do
  let(:pair) { described_class.new(key: key, value: value) }

  let(:key) { :foo }
  let(:value) { :bar }

  example_group "attributes" do
    subject { pair }

    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    it { is_expected.to respond_to(:key) }
    it { is_expected.to respond_to(:value) }
  end

  example_group "comparison" do
    describe "#==" do
      context "when `other` has different class" do
        let(:other) { 42 }

        it "returns `nil`" do
          expect(pair == other).to be_nil
        end
      end

      context "when `other` has different `key`" do
        let(:other) { described_class.new(key: :bar, value: value) }

        it "returns `true`" do
          expect(pair == other).to be(false)
        end
      end

      context "when `other` has different `value`" do
        let(:other) { described_class.new(key: key, value: :foo) }

        it "returns `true`" do
          expect(pair == other).to be(false)
        end
      end

      context "when `other` has same attributes" do
        let(:other) { described_class.new(key: key, value: value) }

        it "returns `true`" do
          expect(pair == other).to be(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

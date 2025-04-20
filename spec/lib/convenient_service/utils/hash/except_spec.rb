# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Hash::Except, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(hash, keys) }
      let(:hash) { {foo: "foo", bar: "bar", baz: "baz"} }

      context "when hash does NOT contain any key from `keys`" do
        let(:keys) { [:qux] }

        it "returns hash with same keys as original hash" do
          expect(command_result.keys).to eq(hash.keys)
        end

        it "copies hash" do
          expect(command_result.object_id).not_to eq(hash.object_id)
        end
      end

      context "when hash contain single key from `keys`" do
        let(:keys) { [:baz] }

        it "returns hash without that key" do
          expect(command_result.keys).to eq(hash.keys - keys)
        end

        it "copies hash" do
          expect(command_result.object_id).not_to eq(hash.object_id)
        end
      end

      context "when hash contain multiple keys from `keys`" do
        let(:keys) { [:foo, :baz] }

        it "returns hash without those keys" do
          expect(command_result.keys).to eq(hash.keys - keys)
        end

        it "copies hash" do
          expect(command_result.object_id).not_to eq(hash.object_id)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

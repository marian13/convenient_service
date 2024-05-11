# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Hash::TripleEqualityCompare, type: :standard do
  example_group "class methods" do
    describe ".call" do
      let(:command_result) { described_class.call(hash, other_hash) }
      let(:hash) { {foo: (1..10), bar: /abc/} }

      context "when `other_hash` has lower amount of keys than hash" do
        let(:other_hash) { {foo: 5} }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when `other_hash` has greater amount of keys than hash" do
        let(:other_hash) { {foo: 5, bar: "abc", baz: :baz} }

        it "returns `false`" do
          expect(command_result).to eq(false)
        end
      end

      context "when `other_hash` has same amount of keys as hash" do
        context "when those keys are NOT same as hash keys" do
          let(:other_hash) { {foo: 5, bar: :baz} }

          it "returns `false`" do
            expect(command_result).to eq(false)
          end
        end

        context "when those keys are same as hash keys" do
          context "when any of `other_hash` corresponding value is NOT same as hash value in terms of `#===`" do
            let(:other_hash) { {foo: -5, bar: "xyz"} }

            it "returns `false`" do
              expect(command_result).to eq(false)
            end
          end

          context "when all of `other_hash` corresponding values are same as hash values in terms of `#===`" do
            let(:other_hash) { {foo: 5, bar: "abc"} }

            it "returns `true`" do
              expect(command_result).to eq(true)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

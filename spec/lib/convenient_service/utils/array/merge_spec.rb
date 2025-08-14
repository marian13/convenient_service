# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::Merge, type: :standard do
  describe ".call" do
    subject(:util_result) { described_class.call(array, overrides, raise_on_non_integer_index: raise_on_non_integer_index) }

    let(:array) { [:a, :b, :c] }
    let(:raise_on_non_integer_index) { true }

    context "when `overrides` is NOT empty" do
      context "when `overrides` contains one `index/value` pair" do
        let(:overrides) { {0 => :foo} }

        it "sets `value` by `index` in `array` for that pair" do
          expect(util_result).to eq([:foo, :b, :c])
        end

        it "returns `array` copy" do
          expect(util_result.object_id).not_to eq(array.object_id)
        end
      end

      context "when `overrides` contains multiple index/value pairs" do
        let(:overrides) { {0 => :foo, 1 => :bar} }

        it "sets `value` by `index` in `array` for those pairs" do
          expect(util_result).to eq([:foo, :bar, :c])
        end

        it "returns `array` copy" do
          expect(util_result.object_id).not_to eq(array.object_id)
        end
      end

      context "when `overrides` contains non integer keys" do
        let(:overrides) { {:a => :foo, 1 => :bar} }

        let(:exception_message) do
          <<~TEXT
            Index `:a` is NOT an integer.
          TEXT
        end

        context "when `raise_on_non_integer_index` is `false`" do
          let(:raise_on_non_integer_index) { false }

          it "skips those non integer keys" do
            expect(util_result).to eq([:a, :bar, :c])
          end
        end

        context "when `raise_on_non_integer_index` is `true`" do
          let(:raise_on_non_integer_index) { true }

          it "raises `ConvenientService::Utils::Array::Exceptions::NonIntegerIndex`" do
            expect { util_result }
              .to raise_error(ConvenientService::Utils::Array::Exceptions::NonIntegerIndex)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { util_result }.to raise_error(ConvenientService::Utils::Array::Exceptions::NonIntegerIndex)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
        end

        context "when `raise_on_non_integer_index` is NOT passed" do
          subject(:util_result) { described_class.call(array, overrides) }

          it "raises `ConvenientService::Utils::Array::Exceptions::NonIntegerIndex`" do
            expect { util_result }
              .to raise_error(ConvenientService::Utils::Array::Exceptions::NonIntegerIndex)
              .with_message(exception_message)
          end

          ##
          # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
          #
          # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
          specify do
            expect(ConvenientService).to receive(:raise).and_call_original

            expect { util_result }.to raise_error(ConvenientService::Utils::Array::Exceptions::NonIntegerIndex)
          end
          # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies
        end
      end
    end

    context "when `overrides` is empty" do
      let(:overrides) { {} }

      it "returns `array` copy" do
        expect(util_result.object_id).not_to eq(array.object_id)
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

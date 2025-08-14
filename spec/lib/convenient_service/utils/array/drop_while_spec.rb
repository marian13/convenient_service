# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::DropWhile, type: :standard do
  describe ".call" do
    let(:array) { [1, 2, 3, 4, 5] }
    let(:condition_block) { proc { |item| item != 3 } }

    context "when `inclusively` is NOT passed" do
      subject(:util_result) { described_class.call(array, &condition_block) }

      it "defaults to `false`" do
        expect(util_result).to eq([3, 4, 5])
      end
    end

    context "when `inclusively` is passed" do
      subject(:util_result) { described_class.call(array, inclusively: inclusively, &condition_block) }

      context "when `inclusively` is `false`" do
        let(:inclusively) { false }

        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        it "delegates to `ConvenientService::Utils::Array::FindYield.call`" do
          expect(array)
            .to receive(:drop_while)
              .and_wrap_original { |_original, *actual_args, **actual_kwargs, &actual_block| expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, condition_block]) }

          util_result
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

        it "returns array without items until condition is met for the first time" do
          expect(util_result).to eq([3, 4, 5])
        end
      end

      context "when `inclusively` is `true`" do
        let(:inclusively) { true }

        # rubocop:disable RSpec/MultipleExpectations, RSpec/MessageSpies
        it "delegates to `ConvenientService::Utils::Array::FindYield.call`" do
          expect(array)
            .to receive(:drop_while)
            .and_wrap_original do |original, *actual_args, **actual_kwargs, &actual_block|
            expect([actual_args, actual_kwargs, actual_block]).to eq([[], {}, condition_block])

            original.call(*actual_args, **actual_kwargs, &actual_block)
          end

          util_result
        end
        # rubocop:enable RSpec/MultipleExpectations, RSpec/MessageSpies

        it "returns array without items until condition is met for the first time" do
          expect(util_result).to eq([4, 5])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

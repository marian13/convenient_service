# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Utils::Array::DropWhile, type: :standard do
  describe ".call" do
    include ConvenientService::RSpec::Matchers::DelegateTo

    let(:array) { [1, 2, 3, 4, 5] }
    let(:condition_block) { proc { |item| item != 3 } }

    context "when `inclusively` is NOT passed" do
      subject(:result) { described_class.call(array, &condition_block) }

      it "defaults to `false`" do
        ##
        # NOTE: Same result as in "when `inclusively` is `false`".
        # TODO: Shared example?
        #
        expect(result).to eq([3, 4, 5])
      end
    end

    context "when `inclusively` is passed" do
      subject(:result) { described_class.call(array, inclusively: inclusively, &condition_block) }

      context "when `inclusively` is `false`" do
        let(:inclusively) { false }

        specify {
          expect { result }.to delegate_to(array, :drop_while).with_arguments(&condition_block)
        }

        it "returns array without items until condition is met for the first time" do
          expect(result).to eq([3, 4, 5])
        end
      end

      context "when `inclusively` is `true`" do
        let(:inclusively) { true }

        specify {
          expect { result }.to delegate_to(array, :drop_while).with_arguments(&condition_block)
        }

        it "returns array without items until condition is met for the first time" do
          expect(result).to eq([4, 5])
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

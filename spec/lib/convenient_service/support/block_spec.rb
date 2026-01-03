# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::Block, type: :standard do
  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Support::UniqueValue).to be(true) }
  end

  example_group "instance methods" do
    describe "#[]" do
      context "when `value` is NOT `ConvenientService::Support::BLOCK`" do
        let(:value) { 42 }

        it "returns `false`" do
          expect(ConvenientService::Support::BLOCK[value]).to be(false)
        end
      end

      context "when `value` is `ConvenientService::Support::BLOCK`" do
        let(:value) { ConvenientService::Support::BLOCK }

        it "returns `true`" do
          expect(ConvenientService::Support::BLOCK[value]).to be(true)
        end
      end
    end
  end

  example_group "constants" do
    describe "::BLOCK" do
      it "returns `ConvenientService::Support::Block` instance" do
        expect(ConvenientService::Support::BLOCK).to be_instance_of(described_class)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(ConvenientService::Support::BLOCK.inspect).to eq("block")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

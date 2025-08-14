# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Support::NotPassed, type: :standard do
  example_group "inheritance" do
    ##
    # NOTE: Do NOT use custom RSpec helpers and matchers inside Utils and Support to avoid cyclic module dependencies.
    #
    specify { expect(described_class < ConvenientService::Support::UniqueValue).to eq(true) }
  end

  example_group "instance methods" do
    describe "#[]" do
      context "when `value` is NOT `ConvenientService::Support::NOT_PASSED`" do
        let(:value) { 42 }

        it "returns `false`" do
          expect(ConvenientService::Support::NOT_PASSED[value]).to eq(false)
        end
      end

      context "when `value` is `ConvenientService::Support::NOT_PASSED`" do
        let(:value) { ConvenientService::Support::NOT_PASSED }

        it "returns `true`" do
          expect(ConvenientService::Support::NOT_PASSED[value]).to eq(true)
        end
      end
    end
  end

  example_group "constants" do
    describe "::NOT_PASSED" do
      it "returns `ConvenientService::Support::NotPassed` instance" do
        expect(ConvenientService::Support::NOT_PASSED).to be_instance_of(described_class)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(ConvenientService::Support::NOT_PASSED.inspect).to eq("not_passed")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

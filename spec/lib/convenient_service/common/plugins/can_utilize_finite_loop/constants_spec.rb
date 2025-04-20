# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe ConvenientService::Common::Plugins::CanUtilizeFiniteLoop::Constants, type: :standard do
  example_group "constants" do
    describe "::MAX_ITERATION_COUNT" do
      it "returns `1_000`" do
        expect(described_class::MAX_ITERATION_COUNT).to eq(1_000)
      end
    end

    describe "::FINITE_LOOP_EXCEEDED" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(described_class::FINITE_LOOP_EXCEEDED).to be_instance_of(ConvenientService::Support::UniqueValue)
      end

      ##
      # NOTE: This example group is for instance methods of constant, that is why it is nested.
      # TODO: Custom matcher.
      #
      example_group "instance methods" do
        describe "#inspect" do
          it "returns inspect representation" do
            expect(described_class::FINITE_LOOP_EXCEEDED.inspect).to eq("finite_loop_exceeded")
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe "convenient_service/support/not_passed", type: :standard do
  example_group "constants" do
    describe "::NOT_PASSED" do
      it "returns `ConvenientService::Support::UniqueValue` instance" do
        expect(ConvenientService::Support::NOT_PASSED).to be_instance_of(ConvenientService::Support::UniqueValue)
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
# rubocop:enable RSpec/NestedGroups, RSpec/DescribeClass

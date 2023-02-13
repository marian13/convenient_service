# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/DescribeClass
RSpec.describe "convenient_service/support/not_passed" do
  example_group "constants" do
    describe "::NOT_PASSED" do
      it "returns `Object` instance" do
        expect(ConvenientService::Support::NOT_PASSED).to be_instance_of(Object)
      end

      example_group "instance_methods" do
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

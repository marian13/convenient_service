# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/support/not_passed" do
  example_group "constants" do
    describe "::NOT_PASSED" do
      it "returns `Object` instance" do
        expect(ConvenientService::Support::NOT_PASSED).to be_instance_of(Object)
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass

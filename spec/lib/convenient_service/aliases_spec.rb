# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases" do
  specify { expect(ConvenientService::Concern).to eq(ConvenientService::Support::Concern) }
end
# rubocop:enable RSpec/DescribeClass

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/configs/standard/aliases" do
  specify { expect(ConvenientService::Standard::V1::Config).to eq(ConvenientService::Service::Configs::Standard::V1) }
end
# rubocop:enable RSpec/DescribeClass

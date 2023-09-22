# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/configs/aliases" do
  specify { expect(ConvenientService::Standard::Config).to eq(ConvenientService::Service::Configs::Standard) }
end
# rubocop:enable RSpec/DescribeClass

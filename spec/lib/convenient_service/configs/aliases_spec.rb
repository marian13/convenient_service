# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/configs/aliases" do
  specify { expect(ConvenientService::Standard::Config).to eq(ConvenientService::Configs::Standard) }
  specify { expect(ConvenientService::Standard::CommittedConfig).to eq(ConvenientService::Configs::StandardCommitted) }
  specify { expect(ConvenientService::Standard::UncommittedConfig).to eq(ConvenientService::Configs::StandardUncommitted) }
end
# rubocop:enable RSpec/DescribeClass

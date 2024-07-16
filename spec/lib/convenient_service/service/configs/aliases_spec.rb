# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/configs/aliases", type: :standard do
  specify { expect(ConvenientService::Standard::Config).to eq(ConvenientService::Service::Configs::Standard) }
  specify { expect(ConvenientService::Inspect::Config).to eq(ConvenientService::Service::Configs::Inspect) }
  specify { expect(ConvenientService::FaultTolerance::Config).to eq(ConvenientService::Service::Configs::FaultTolerance) }
end
# rubocop:enable RSpec/DescribeClass

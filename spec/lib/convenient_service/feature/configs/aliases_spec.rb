# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/feature/configs/aliases", type: :standard do
  specify { expect(ConvenientService::Feature::Standard::Config).to eq(ConvenientService::Feature::Configs::Standard) }
  specify { expect(ConvenientService::Feature::RSpec::Config).to eq(ConvenientService::Feature::Configs::RSpec) }
end
# rubocop:enable RSpec/DescribeClass

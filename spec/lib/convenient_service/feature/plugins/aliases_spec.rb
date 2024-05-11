# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/feature/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Feature).to eq(ConvenientService::Feature::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/common/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Common).to eq(ConvenientService::Common::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

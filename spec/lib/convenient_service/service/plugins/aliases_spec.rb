# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Service).to eq(ConvenientService::Service::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

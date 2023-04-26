# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/has_result/entities/result/plugins/aliases" do
  specify { expect(ConvenientService::Plugins::Result).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

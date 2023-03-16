# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/aliases" do
  specify { expect(ConvenientService::Plugins::Result).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins) }
  specify { expect(ConvenientService::Plugins::Service).to eq(ConvenientService::Service::Plugins) }
  specify { expect(ConvenientService::Plugins::Step).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

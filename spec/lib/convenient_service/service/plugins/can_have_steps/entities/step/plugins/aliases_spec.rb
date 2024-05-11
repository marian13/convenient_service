# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/can_have_steps/entities/step/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Step).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

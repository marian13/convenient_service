# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases" do
  specify { expect(ConvenientService::DependencyContainer).to eq(ConvenientService::Support::DependencyContainer) }
end
# rubocop:enable RSpec/DescribeClass

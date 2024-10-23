# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases", type: :standard do
  specify { expect(ConvenientService::Command).to eq(ConvenientService::Support::Command) }
  specify { expect(ConvenientService::Concern).to eq(ConvenientService::Support::Concern) }
  specify { expect(ConvenientService::DependencyContainer).to eq(ConvenientService::Support::DependencyContainer) }

  specify { expect(ConvenientService::Config).to eq(ConvenientService::Service::Config) }
end
# rubocop:enable RSpec/DescribeClass

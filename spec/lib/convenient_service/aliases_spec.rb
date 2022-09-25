# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases" do
  specify { expect(ConvenientService::Plugins::Common).to eq(ConvenientService::Common::Plugins) }
  specify { expect(ConvenientService::Plugins::Internals).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins) }
  specify { expect(ConvenientService::Plugins::Result).to eq(ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins) }
  specify { expect(ConvenientService::Plugins::Service).to eq(ConvenientService::Service::Plugins) }
  specify { expect(ConvenientService::Standard::Config).to eq(ConvenientService::Configs::Standard) }
  specify { expect(ConvenientService::Standard::CommittedConfig).to eq(ConvenientService::Configs::StandardCommitted) }
  specify { expect(ConvenientService::Standard::UncommittedConfig).to eq(ConvenientService::Configs::StandardUncommitted) }
end
# rubocop:enable RSpec/DescribeClass

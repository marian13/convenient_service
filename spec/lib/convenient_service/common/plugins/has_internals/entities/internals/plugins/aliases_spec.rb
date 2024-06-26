# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/common/plugins/has_internals/entities/internals/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Internals).to eq(ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

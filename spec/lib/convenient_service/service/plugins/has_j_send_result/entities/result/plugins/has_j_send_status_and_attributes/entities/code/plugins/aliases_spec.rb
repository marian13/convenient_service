# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/code/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Code).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

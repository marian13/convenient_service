# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/message/plugins/aliases" do
  specify { expect(ConvenientService::Plugins::Message).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

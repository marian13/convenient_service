# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/has_j_send_result/entities/result/plugins/has_j_send_status_and_attributes/entities/status/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Status).to eq(ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/configs/standard/aliases", type: :standard do
  specify { expect(ConvenientService::Standard::V1::Config).to eq(ConvenientService::Service::Configs::Standard::V1) }
end
# rubocop:enable RSpec/DescribeClass

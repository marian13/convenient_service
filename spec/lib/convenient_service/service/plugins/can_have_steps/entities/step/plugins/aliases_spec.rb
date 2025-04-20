# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/service/plugins/can_have_steps/entities/step/plugins/aliases", type: :standard do
  specify { expect(ConvenientService::Plugins::Step).to eq(ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins) }
end
# rubocop:enable RSpec/DescribeClass

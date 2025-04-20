# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "convenient_service/aliases", type: :standard do
  specify { expect(ConvenientService::Command).to eq(ConvenientService::Support::Command) }
  specify { expect(ConvenientService::Concern).to eq(ConvenientService::Support::Concern) }
  specify { expect(ConvenientService::DependencyContainer).to eq(ConvenientService::Support::DependencyContainer) }
end
# rubocop:enable RSpec/DescribeClass

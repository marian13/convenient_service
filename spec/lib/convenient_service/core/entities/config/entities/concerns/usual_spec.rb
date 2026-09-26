# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Entities::Concerns::Usual, type: :standard do
  specify { expect(described_class).to eq(ConvenientService::Support::Concern) }
end

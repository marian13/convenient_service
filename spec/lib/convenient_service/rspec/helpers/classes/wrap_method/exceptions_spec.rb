# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ChainAttributePreliminaryAccess).to be_descendant_of(ConvenientService::Exception) }
end

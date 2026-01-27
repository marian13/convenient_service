# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveModifiedData::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::NotExistingAttributeForOnly).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::NotExistingAttributeForExcept).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::NotExistingAttributeForRename).to be_descendant_of(ConvenientService::Exception) }
end

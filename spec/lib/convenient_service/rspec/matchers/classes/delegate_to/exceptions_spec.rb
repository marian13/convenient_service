# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::DelegateTo::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::CallOriginalChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ArgumentsChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ReturnValueChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ReturnCustomValueChainingInvalidArguments).to be_descendant_of(ConvenientService::Exception) }
end

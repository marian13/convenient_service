# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::FirstStepIsNotSet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::FirstGroupStepIsNotSet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::EmptyExpressionHasNoResult).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::EmptyExpressionHasNoStatus).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ServiceHasNoSteps).to be_descendant_of(ConvenientService::Exception) }
end

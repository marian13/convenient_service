# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::ForbidsConvenientServiceEntitiesAsConstructorArguments::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::ServicePassedAsConstructorArgument).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::StepPassedAsConstructorArgument).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ResultPassedAsConstructorArgument).to be_descendant_of(ConvenientService::Exception) }
end

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions, type: :standard do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::MethodHasNoOrganizer).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::MethodIsNotOutputMethod).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::OutMethodStepIsNotCompleted).to be_descendant_of(ConvenientService::Exception) }
end

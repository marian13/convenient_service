# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::StepHasNoOrganizer).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::StepResultDataNotExistingAttribute).to be_descendant_of(ConvenientService::Exception) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::MethodHasNoOrganizer).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::MethodIsNotOutputMethod).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::OutMethodStepIsNotCompleted).to be_descendant_of(ConvenientService::Exception) }
end

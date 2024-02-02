# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::FirstStepIsNotSet).to be_descendant_of(ConvenientService::Exception) }
end

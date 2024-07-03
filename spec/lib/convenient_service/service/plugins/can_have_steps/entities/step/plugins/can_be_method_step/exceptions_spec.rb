# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step::Plugins::CanBeMethodStep::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::StepIsNotMethodStep).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::MethodForStepIsNotDefined).to be_descendant_of(ConvenientService::Exception) }
end

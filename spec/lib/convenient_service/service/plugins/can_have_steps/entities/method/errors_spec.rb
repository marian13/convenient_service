# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::MethodHasNoOrganizer).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::InputMethodIsNotDefinedInContainer).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::OutputMethodIsDefinedInContainer).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::AliasInputMethodIsNotDefinedInContainer).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::AliasOutputMethodIsDefinedInContainer).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::OutputMethodProc).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::OutputMethodRawValue).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::CallerCanNotCalculateReassignment).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::InputMethodReassignment).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::MethodIsNotInputMethod).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::MethodIsNotOutputMethod).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::NotCompletedStep).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::NotExistingStepResultDataAttribute).to be_descendant_of(ConvenientService::Error) }
end

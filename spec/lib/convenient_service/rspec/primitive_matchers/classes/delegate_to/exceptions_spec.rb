# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::CallOriginalChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ArgumentsChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ReturnValueChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ReturnCustomValueChainingInvalidArguments).to be_descendant_of(ConvenientService::Exception) }
end

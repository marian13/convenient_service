# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveMatchers::Classes::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::CallOriginalChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ArgumentsChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ReturnValueChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ComparingByChainingIsAlreadySet).to be_descendant_of(ConvenientService::Exception) }
end

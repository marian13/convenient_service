# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::Matcher::Entities::ChainingsCollection::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::CallOriginalChainingIsAlreadySet).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::ArgumentsChainingIsAlreadySet).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::ReturnItsValueChainingIsAlreadySet).to be_descendant_of(ConvenientService::Error) }
end

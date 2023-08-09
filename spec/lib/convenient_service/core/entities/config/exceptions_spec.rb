# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core::Entities::Config::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ConfigIsCommitted).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::TooManyCommitsFromMethodMissing).to be_descendant_of(ConvenientService::Exception) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Feature::Plugins::CanHaveEntries::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::NotDefinedEntryMethod).to be_descendant_of(ConvenientService::Exception) }
end

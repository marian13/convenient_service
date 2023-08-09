# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Custom::WrapMethod::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ChainAttributePreliminaryAccess).to be_descendant_of(ConvenientService::Exception) }
end

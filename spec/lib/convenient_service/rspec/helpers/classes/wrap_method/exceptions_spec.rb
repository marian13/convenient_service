# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Classes::WrapMethod::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::ChainAttributePreliminaryAccess).to be_descendant_of(ConvenientService::Exception) }
end

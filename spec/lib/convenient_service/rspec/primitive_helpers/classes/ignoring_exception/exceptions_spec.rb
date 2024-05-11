# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::PrimitiveHelpers::Classes::IgnoringException::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::IgnoredExceptionIsNotRaised).to be_descendant_of(ConvenientService::Exception) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Classes::IgnoringException::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::IgnoredExceptionIsNotRaised).to be_descendant_of(ConvenientService::Exception) }
end

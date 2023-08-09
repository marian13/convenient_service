# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Helpers::Custom::IgnoringError::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::IgnoredErrorIsNotRaised).to be_descendant_of(ConvenientService::Exception) }
end

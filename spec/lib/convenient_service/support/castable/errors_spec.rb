# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::Castable::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::CastIsNotOverridden).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::FailedToCast).to be_descendant_of(ConvenientService::Error) }
end

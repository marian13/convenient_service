# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::Castable::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::CastIsNotOverridden).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::FailedToCast).to be_descendant_of(ConvenientService::Exception) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Classes::Results::Base::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::InvalidStep).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::InvalidStepIndex).to be_descendant_of(ConvenientService::Exception) }
end

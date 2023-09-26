# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::HasAroundCallbacks::Exceptions do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::AroundCallbackChainIsNotContinued).to be_descendant_of(ConvenientService::Exception) }
end

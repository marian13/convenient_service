# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::CanBeTried::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::TryResultIsNotOverridden).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ServiceTryReturnValueNotSuccess).to be_descendant_of(ConvenientService::Exception) }
end

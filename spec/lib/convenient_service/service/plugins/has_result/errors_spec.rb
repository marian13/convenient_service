# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ResultIsNotOverridden).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::ServiceReturnValueNotKindOfResult).to be_descendant_of(ConvenientService::Error) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::NotExistingAttribute).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ErrorHasNoOtherTypeRepresentation).to be_descendant_of(ConvenientService::Exception) }
end

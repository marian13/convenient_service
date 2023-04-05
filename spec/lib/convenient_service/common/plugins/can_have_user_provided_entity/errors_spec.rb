# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::ProtoEntityHasNoName).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::ProtoEntityHasNoConcern).to be_descendant_of(ConvenientService::Error) }
end

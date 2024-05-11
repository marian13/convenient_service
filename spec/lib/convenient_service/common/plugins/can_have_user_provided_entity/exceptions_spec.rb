# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::ProtoEntityHasNoName).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::ProtoEntityHasNoConcern).to be_descendant_of(ConvenientService::Exception) }
end

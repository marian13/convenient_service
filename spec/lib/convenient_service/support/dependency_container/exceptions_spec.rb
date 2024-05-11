# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::DependencyContainer::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::InvalidScope).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::NotExportableModule).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::NotExportedMethod).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::NotModule).to be_descendant_of(ConvenientService::Exception) }
end

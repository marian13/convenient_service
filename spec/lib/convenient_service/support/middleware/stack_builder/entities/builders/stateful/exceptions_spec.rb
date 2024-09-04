# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::Middleware::StackBuilder::Entities::Builders::Stateful::Exceptions, type: :standard do
  include ConvenientService::RSpec::PrimitiveMatchers::BeDescendantOf

  specify { expect(described_class::MissingMiddleware).to be_descendant_of(ConvenientService::Exception) }
end

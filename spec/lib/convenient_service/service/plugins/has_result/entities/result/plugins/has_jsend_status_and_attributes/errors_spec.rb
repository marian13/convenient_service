# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::NotExistingAttribute).to be_descendant_of(ConvenientService::Error) }
end

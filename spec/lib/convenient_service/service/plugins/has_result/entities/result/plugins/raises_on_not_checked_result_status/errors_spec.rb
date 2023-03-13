# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::RaisesOnNotCheckedResultStatus::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::StatusIsNotChecked).to be_descendant_of(ConvenientService::Error) }
end

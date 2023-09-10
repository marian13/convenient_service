# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::KwargsContainJSendAndExtraKeys).to be_descendant_of(ConvenientService::Exception) }
end

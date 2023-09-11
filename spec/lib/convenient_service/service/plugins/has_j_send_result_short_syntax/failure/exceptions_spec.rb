# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Exceptions do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::BothArgsAndKwargsArePassed).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::KwargsContainJSendAndExtraKeys).to be_descendant_of(ConvenientService::Exception) }
  specify { expect(described_class::MoreThanTwoArgsArePassed).to be_descendant_of(ConvenientService::Exception) }
end

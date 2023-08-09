# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Error::Errors do
  include ConvenientService::RSpec::Matchers::BeDescendantOf

  specify { expect(described_class::BothArgsAndKwargsArePassed).to be_descendant_of(ConvenientService::Error) }
  specify { expect(described_class::MoreThanTwoArgsArePassed).to be_descendant_of(ConvenientService::Error) }
end

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Feature do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Entry) }
    it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Export) }
  end
end

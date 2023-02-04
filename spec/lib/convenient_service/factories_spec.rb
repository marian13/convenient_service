# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Factories do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to extend_module(ConvenientService::Factories::Services) }
    it { is_expected.to extend_module(ConvenientService::Factories::Results) }
    it { is_expected.to extend_module(ConvenientService::Factories::Steps) }
  end
end

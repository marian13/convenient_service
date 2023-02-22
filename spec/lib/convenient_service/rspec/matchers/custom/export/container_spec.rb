# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::RSpec::Matchers::Custom::Export::Container do
  subject { described_class }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    it { is_expected.to include_module(ConvenientService::DependencyContainer::Export) }
  end

  example_group "exported methods" do
    include ConvenientService::RSpec::Matchers::Export

    it { is_expected.to export(:"DependencyContainer::Constants::DEFAULT_SCOPE") }

    it { is_expected.to export(:"DependencyContainer::Commands::AssertValidContainer") }

    it { is_expected.to export(:"DependencyContainer::Commands::AssertValidScope") }
  end
end

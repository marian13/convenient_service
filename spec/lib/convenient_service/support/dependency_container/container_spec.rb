# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Support::DependencyContainer::Container do
  subject { described_class }

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    it { is_expected.to include_module(ConvenientService::DependencyContainer::Export) }
  end

  example_group "exported methods" do
    include ConvenientService::RSpec::Matchers::Export

    it { is_expected.to export(:"constants.DEFAULT_ALIAS_SLUG") }

    it { is_expected.to export(:"constants.DEFAULT_SCOPE") }

    it { is_expected.to export(:"constants.DEFAULT_PREPEND") }

    it { is_expected.to export(:"commands.AssertValidContainer") }

    it { is_expected.to export(:"commands.AssertValidScope") }

    it { is_expected.to export(:"commands.AssertValidMethod") }

    it { is_expected.to export(:"commands.GetNamespace") }

    it { is_expected.to export(:"entities.Method") }
  end
end

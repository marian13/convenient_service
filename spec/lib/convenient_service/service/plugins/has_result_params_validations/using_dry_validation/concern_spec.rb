# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResultParamsValidations::UsingDryValidation::Concern do
  include ConvenientService::RSpec::Matchers::IncludeModule
  include ConvenientService::RSpec::Matchers::ExtendModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }
  end

  example_group "when included" do
    subject do
      Class.new.tap do |klass|
        klass.class_exec(described_class) do |mod|
          include mod
        end
      end
    end

    it { is_expected.to extend_module(described_class::ClassMethods) }
  end
end

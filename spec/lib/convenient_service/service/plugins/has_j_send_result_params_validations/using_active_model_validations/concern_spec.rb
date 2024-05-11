# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations

RSpec.describe ConvenientService::Service::Plugins::HasJSendResultParamsValidations::UsingActiveModelValidations::Concern, type: :standard do
  include ConvenientService::RSpec::Matchers::IncludeModule

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

    it { is_expected.to include_module(ActiveModel::Validations) }
  end
end

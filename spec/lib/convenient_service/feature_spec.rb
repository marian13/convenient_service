# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Feature do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { container }

      let(:container) do
        Module.new.tap do |container|
          container.module_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Entry) }
      it { is_expected.to include_module(ConvenientService::Support::DependencyContainer::Export) }
    end
  end
end

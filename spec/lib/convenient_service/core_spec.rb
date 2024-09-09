# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Core, type: :standard do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::DelegateTo

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      let(:entity_class) { Class.new }

      specify do
        expect(entity_class.include described_class).to include_module(described_class::Concern)
      end

      ##
      # NOTE: Ensures `__convenient_service_config__` is called in the `included` block.
      #
      specify do
        expect { entity_class.include described_class }
          .to delegate_to(ConvenientService::Core::Entities::Config, :new)
          .with_arguments(klass: entity_class)
      end
    end
  end
end

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
      let(:config) { ConvenientService::Core::Entities::Config.new(klass: entity_class) }

      specify do
        expect(entity_class.include described_class).to include_module(described_class::Concern)
      end

      specify do
        allow(ConvenientService::Core::Entities::Config).to receive(:new).with(klass: entity_class).and_return(config)

        expect { entity_class.include described_class }
          .to delegate_to(config, :mutex)
          .without_arguments
      end
    end
  end
end

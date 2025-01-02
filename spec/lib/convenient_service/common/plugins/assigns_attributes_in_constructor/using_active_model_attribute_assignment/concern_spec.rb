# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment

RSpec.describe ConvenientService::Common::Plugins::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment::Concern, type: :rails do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { service_class }

      let(:service_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(ActiveModel::AttributeAssignment) }
    end
  end
end

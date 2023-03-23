# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Support::Concern) }

    context "when included" do
      subject { result_class }

      let(:result_class) do
        Class.new.tap do |klass|
          klass.class_exec(described_class) do |mod|
            include mod
          end
        end
      end

      it { is_expected.to include_module(described_class::InstanceMethods) }
      it { is_expected.to extend_module(described_class::ClassMethods) }
    end
  end
end

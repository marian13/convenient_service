# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Service::Plugins::HasResultStatusCheckShortSyntax::Concern do
  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule
    include ConvenientService::RSpec::Matchers::ExtendModule

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

      it { is_expected.to extend_module(described_class::ClassMethods) }

      it { is_expected.to respond_to(:success?) }

      it { is_expected.to respond_to(:error?) }

      it { is_expected.to respond_to(:failure?) }

      it { is_expected.to respond_to(:not_success?) }

      it { is_expected.to respond_to(:not_error?) }

      it { is_expected.to respond_to(:not_failure?) }
    end
  end
end

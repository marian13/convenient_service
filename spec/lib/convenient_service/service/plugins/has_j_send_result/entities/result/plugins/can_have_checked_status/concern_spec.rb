# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::CanHaveCheckedStatus::Concern do
  include ConvenientService::RSpec::Matchers::DelegateTo

  example_group "modules" do
    include ConvenientService::RSpec::Matchers::IncludeModule

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
    end
  end

  example_group "instance methods" do
    let(:service) do
      Class.new do
        include ConvenientService::Configs::Standard

        def result
          success
        end
      end
    end

    let(:result) { service.result }

    describe "#has_checked_status?" do
      context "when status is NOT checked" do
        before do
          result.success?(mark_status_as_checked: false)
        end

        it "returns `false`" do
          expect(result.has_checked_status?).to eq(false)
        end
      end

      context "when status is checked" do
        before do
          result.success?
        end

        it "returns `true`" do
          expect(result.has_checked_status?).to eq(true)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

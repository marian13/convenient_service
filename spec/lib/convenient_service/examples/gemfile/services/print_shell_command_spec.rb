# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Gemfile::Services::PrintShellCommand do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrAccessor
  include ConvenientService::RSpec::Matchers::IncludeModule
  include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {text: text, out: out} }
  let(:text) { "ls -a" }
  let(:out) { Tempfile.new }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Configs::Standard) }
    it { is_expected.to include_module(ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment) }
    it { is_expected.to include_module(ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes) }
    it { is_expected.to include_module(ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_accessor(:text) }
    it { is_expected.to have_attr_accessor(:out) }
  end

  example_group "validations" do
    subject { service }

    it { is_expected.to validate_presence_of(:text) }
  end

  describe "#result" do
    subject(:result) { service.result }

    let(:out_content) { out.tap(&:rewind).read }

    it "prints text" do
      result

      expect(out_content).to match(/\$ #{text}/)
    end

    it "delegates to Paint#[]" do
      allow(Paint).to receive(:[]).with("$ #{text}", :blue, :bold).and_call_original

      result

      expect(Paint).to have_received(:[])
    end
  end
end

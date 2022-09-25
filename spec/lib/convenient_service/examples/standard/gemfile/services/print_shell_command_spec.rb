# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::PrintShellCommand do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {text: text, out: out} }
  let(:text) { "ls -a" }
  let(:out) { Tempfile.new }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:text) }
    it { is_expected.to have_attr_reader(:out) }
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

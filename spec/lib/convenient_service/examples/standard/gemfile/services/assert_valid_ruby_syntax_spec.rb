# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::AssertValidRubySyntax do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {content: content} }
  let(:content) { double }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:content) }
  end

  describe "#result" do
    subject(:result) { described_class.result(**default_options) }

    context "when content does NOT contain valid Ruby syntax" do
      let(:content) { "2 */ 2" }

      it "returns error with message" do
        expect(result).to be_error.with_message("`#{content}` contains invalid Ruby syntax")
      end
    end

    context "when content contains valid Ruby syntax" do
      let(:content) { "2 + 2" }

      it "returns success" do
        expect(result).to be_success
      end
    end
  end
end

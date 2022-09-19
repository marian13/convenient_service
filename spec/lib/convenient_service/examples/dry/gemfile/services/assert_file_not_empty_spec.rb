# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::AssertFileNotEmpty do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path} }
  let(:path) { double }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryServiceConfig) }
  end

  describe "#result" do
    subject(:result) { service.result }

    let(:path) { tempfile.path }

    context "when file is NOT empty" do
      ##
      # NOTE: Tempfile uses its own let in order to prevent its premature garbage collection.
      #
      let(:tempfile) { Tempfile.new.tap { |file| file.write("content") }.tap(&:close) }

      it "returns success" do
        ##
        # TODO: Matcher.
        #
        expect(result).to be_success
      end
    end

    context "when file is empty" do
      ##
      # NOTE: Tempfile uses its own let in order to prevent its premature garbage collection.
      #
      let(:tempfile) { Tempfile.new }

      it "returns error with message" do
        expect(result).to be_error.with_message("File with path `#{path}' is empty")
      end
    end
  end
end

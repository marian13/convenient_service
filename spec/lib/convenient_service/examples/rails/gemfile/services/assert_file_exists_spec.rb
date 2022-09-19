# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::AssertFileExists do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrAccessor
  include ConvenientService::RSpec::Matchers::IncludeModule
  include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path} }
  let(:path) { double }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsServiceConfig) }
  end

  example_group "attributes" do
    subject { service }

    ##
    # NOTE: have_attr_writer is needed by `validate_presence_of'.
    # https://stackoverflow.com/a/31686199/12201472
    #
    it { is_expected.to have_attr_accessor(:path) }
  end

  ##
  # NOTE: Waits for `should-matchers' support.
  #
  # example_group "validations" do
  #   subject { service }
  #
  #   it { is_expected.to validate_presence_of(:path) }
  # end

  describe "#result" do
    subject(:result) { service.result }

    context "when file with path does NOT exist" do
      let(:path) { "non_existing_path" }

      it "returns error with message" do
        expect(result).to be_error.with_message("File with path `#{path}' does NOT exist")
      end
    end

    context "when file with path exists" do
      ##
      # NOTE: Tempfile uses its own let in order to prevent its premature garbage collection.
      #
      let(:tempfile) { Tempfile.new }
      let(:path) { tempfile.path }

      it "returns success" do
        ##
        # TODO: Matcher.
        #
        expect(result).to be_success
      end
    end
  end
end

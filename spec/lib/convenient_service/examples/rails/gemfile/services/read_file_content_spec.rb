# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::ReadFileContent do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrAccessor
  include ConvenientService::RSpec::Matchers::IncludeModule
  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path} }
  let(:path) { "some path" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsService::Config) }
  end

  example_group "attributes" do
    subject { service }

    ##
    # NOTE: have_attr_writer is needed by `validate_presence_of`.
    # https://stackoverflow.com/a/31686199/12201472
    #
    it { is_expected.to have_attr_accessor(:path) }
  end

  ##
  # NOTE: Waits for `should-matchers` full support.
  #
  # example_group "validations" do
  #   subject { service }
  #
  #   it { is_expected.to validate_presence_of(:path) }
  # end

  describe "#result" do
    subject(:result) { service.result }

    if ConvenientService::Dependencies.support_has_result_params_validations_using_active_model_validations?
      context "when path is NOT present" do
        let(:path) { "" }

        it "returns failure with data" do
          expect(result).to be_failure.with_data(path: "can't be blank")
        end
      end
    end

    context "when file does NOT exist" do
      before do
        stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_error
      end

      it "returns intermediate step result" do
        expect(result).to be_not_success.of_step(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileExists)
      end
    end

    context "when file exists" do
      let(:path) { temfile.path }

      before do
        stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_success
      end

      context "when file is NOT empty" do
        let(:temfile) { Tempfile.new.tap { |tempfile| tempfile.write(content) }.tap(&:close) }
        let(:content) { "some content" }

        before do
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileNotEmpty)
            .with_arguments(path: path)
            .to return_success
        end

        it "returns success with content" do
          expect(result).to be_success.with_data({content: content})
        end
      end

      context "when file is empty" do
        let(:temfile) { Tempfile.new }

        before do
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileNotEmpty)
            .with_arguments(path: path)
            .to return_error
        end

        it "returns intermediate step result" do
          expect(result).to be_not_success.of_step(ConvenientService::Examples::Rails::Gemfile::Services::AssertFileNotEmpty)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

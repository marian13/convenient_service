# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::ReadFileContent do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path} }
  let(:path) { "Gemfile" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when path is NOT present" do
      let(:path) { "" }

      it "returns failure with data" do
        expect(result).to be_failure.with_data(path: "must be filled")
      end
    end

    context "when file does NOT exist" do
      before do
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_error
      end

      it "returns intermediate step result" do
        expect(result).to be_not_success.of(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileExists)
      end
    end

    context "when file exists" do
      let(:path) { temfile.path }

      before do
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_success
      end

      context "when file is NOT empty" do
        let(:temfile) { Tempfile.new.tap { |tempfile| tempfile.write(content) }.tap(&:close) }
        let(:content) { "some content" }

        before do
          stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileNotEmpty)
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
          stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileNotEmpty)
            .with_arguments(path: path)
            .to return_error
        end

        it "returns intermediate step result" do
          expect(result).to be_not_success.of(ConvenientService::Examples::Dry::Gemfile::Services::AssertFileNotEmpty)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {path: path} }
  let(:path) { "some path" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:path) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when file does NOT exist" do
      before do
        stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_error
      end

      it "returns intermediate error" do
        expect(result).to be_error.of(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists)
      end
    end

    context "when file exists" do
      let(:path) { temfile.path }

      before do
        stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists)
          .with_arguments(path: path)
          .to return_success
      end

      context "when file is NOT empty" do
        let(:temfile) { Tempfile.new.tap { |tempfile| tempfile.write(content) }.tap(&:close) }
        let(:content) { "some content" }

        before do
          stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty)
            .with_arguments(path: path)
            .to return_success
        end

        it "return success with content" do
          expect(result).to be_success.with_data({content: content})
        end
      end

      context "when file is empty" do
        let(:temfile) { Tempfile.new }

        before do
          stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty)
            .with_arguments(path: path)
            .to return_error
        end

        it "returns intermediate error" do
          expect(result).to be_error.of(ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

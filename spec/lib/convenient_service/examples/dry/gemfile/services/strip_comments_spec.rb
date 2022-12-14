# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::StripComments do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {content: content} }
  let(:content) { double }
  let(:npm_package_name) { "strip-comments" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    let(:content) do
      <<~RUBY
        ##
        # Coloring for debugging.
        #
        gem "awesome_print", "~> 1.9.2"

        ##
        # Helps to avoid N + 1 in GraphQL resolvers.
        #
        gem "batch-loader", "~> 2.0.1"
      RUBY
    end

    let(:content_without_comments) do
      <<~RUBY



        gem "awesome_print", "~> 1.9.2"




        gem "batch-loader", "~> 2.0.1"
      RUBY
    end

    context "when content is NOT present" do
      let(:content) { "" }

      it "returns failure with data" do
        expect(result).to be_failure.with_data(content: "must be filled")
      end
    end

    context "when `strip-comments` npm package is not available" do
      before do
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertNpmPackageAvailable)
          .with_arguments(name: npm_package_name)
          .to return_error
      end

      it "returns intermediate step result" do
        expect(result).to be_not_success.of(ConvenientService::Examples::Dry::Gemfile::Services::AssertNpmPackageAvailable)
      end
    end

    context "when `strip-comments` npm package is available" do
      before do
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertNpmPackageAvailable)
          .with_arguments(name: npm_package_name)
          .to return_success

        ##
        # NOTE: Stub for environments where Node.js is not available.
        # TODO: Node.js independent examples.
        #
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::RunShell).to return_success
      end

      ##
      # NOTE: Stub for environments where Node.js is not available.
      # TODO: Integration test.
      # TODO: different content variations.
      #
      it "returns success with content without comments" do
        expect(result).to be_success.with_data({content_without_comments: ""})
      end
    end
  end
end

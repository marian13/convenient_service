# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::AssertNpmPackageAvailable do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrReader
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {name: name} }
  let(:name) { "strip-comments" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Configs::Standard) }
  end

  example_group "attributes" do
    subject { service }

    it { is_expected.to have_attr_reader(:name) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when name is NOT valid" do
      context "when name is `nil'" do
        let(:name) { nil }

        it "returns failure with data" do
          expect(result).to be_failure.with_data(name: "Name is `nil'")
        end
      end

      context "when name is empty" do
        let(:name) { "" }

        it "returns failure with data" do
          expect(result).to be_failure.with_data(name: "Name is empty")
        end
      end
    end

    context "when name is valid" do
      let(:name) { "strip-comments" }

      before do
        stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable).to return_error
      end

      context "when node is NOT available" do
        it "returns intermediate error" do
          expect(result).to be_error.of(ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable)
        end
      end

      context "when node is available" do
        let(:npm_package_available_command) { "npm list #{name} --depth=0 > /dev/null 2>&1" }

        before do
          stub_service(ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable).to return_success
        end

        context "when npm package is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
              .with_arguments(command: npm_package_available_command)
              .to return_error
          end

          it "returns intermediate error" do
            expect(result).to be_error.of(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
          end
        end

        context "when npm package is available" do
          before do
            stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
              .with_arguments(command: npm_package_available_command)
              .to return_success
          end

          it "returns success" do
            expect(result).to be_success.of(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

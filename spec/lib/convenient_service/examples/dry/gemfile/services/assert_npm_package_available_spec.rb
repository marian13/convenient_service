# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::Gemfile::Services::AssertNpmPackageAvailable do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {name: name} }
  let(:name) { "strip-comments" }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::Gemfile::DryService::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    context "when name is NOT valid" do
      context "when name is NOT present" do
        let(:name) { "" }

        it "returns failure with data" do
          expect(result).to be_failure.with_data(name: "must be filled")
        end
      end
    end

    context "when name is valid" do
      before do
        stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertNodeAvailable).to return_error
      end

      context "when node is NOT available" do
        it "returns intermediate step result" do
          expect(result).to be_not_success.of(ConvenientService::Examples::Dry::Gemfile::Services::AssertNodeAvailable)
        end
      end

      context "when node is available" do
        let(:npm_package_available_command) { "npm list #{name} --depth=0 > /dev/null 2>&1" }

        before do
          stub_service(ConvenientService::Examples::Dry::Gemfile::Services::AssertNodeAvailable).to return_success
        end

        context "when npm package is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Dry::Gemfile::Services::RunShell)
              .with_arguments(command: npm_package_available_command)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of(ConvenientService::Examples::Dry::Gemfile::Services::RunShell)
          end
        end

        context "when npm package is available" do
          before do
            stub_service(ConvenientService::Examples::Dry::Gemfile::Services::RunShell)
              .with_arguments(command: npm_package_available_command)
              .to return_success
          end

          it "returns success" do
            expect(result).to be_success.of(ConvenientService::Examples::Dry::Gemfile::Services::RunShell)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

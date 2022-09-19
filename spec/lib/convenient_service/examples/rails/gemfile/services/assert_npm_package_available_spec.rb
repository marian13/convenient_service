# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Rails

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Rails::Gemfile::Services::AssertNpmPackageAvailable do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::HaveAttrAccessor
  include ConvenientService::RSpec::Matchers::IncludeModule
  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # include Shoulda::Matchers::ActiveModel

  let(:service) { described_class.new(**default_options) }

  let(:default_options) { {name: name} }
  let(:name) { double }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Rails::Gemfile::RailsServiceConfig) }
  end

  ##
  # NOTE: have_attr_writer is needed by `validate_presence_of'.
  # https://stackoverflow.com/a/31686199/12201472
  #
  it { is_expected.to have_attr_accessor(:name) }

  ##
  # NOTE: Waits for `should-matchers' full support.
  #
  # it { is_expected.to validate_presence_of(:name) }

  describe "#result" do
    subject(:result) { service.result }

    before do
      stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertNodeAvailable).to return_error
    end

    context "when node is NOT available" do
      it "returns intermediate error" do
        expect(result).to be_error.of(ConvenientService::Examples::Rails::Gemfile::Services::AssertNodeAvailable)
      end
    end

    context "when node is available" do
      let(:npm_package_available_command) { "npm list #{name} --depth=0 > /dev/null 2>&1" }

      before do
        stub_service(ConvenientService::Examples::Rails::Gemfile::Services::AssertNodeAvailable).to return_success
      end

      context "when npm package is NOT available" do
        before do
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::RunShell)
            .with_arguments(command: npm_package_available_command)
            .to return_error
        end

        it "returns intermediate error" do
          expect(result).to be_error.of(ConvenientService::Examples::Rails::Gemfile::Services::RunShell)
        end
      end

      context "when npm package is available" do
        before do
          stub_service(ConvenientService::Examples::Rails::Gemfile::Services::RunShell)
            .with_arguments(command: npm_package_available_command)
            .to return_success
        end

        it "returns success" do
          expect(result).to be_success.of(ConvenientService::Examples::Rails::Gemfile::Services::RunShell)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

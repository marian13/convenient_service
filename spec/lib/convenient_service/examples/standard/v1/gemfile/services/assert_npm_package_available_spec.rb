# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Standard

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertNpmPackageAvailable, type: :standard do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::V1::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(name: name) }

      let(:name) { "strip-comments" }
      let(:npm_package_available_command) { "npm list #{name} --depth=0 > /dev/null 2>&1" }

      context "when `AssertNpmPackageAvailable` is NOT successful" do
        context "when `name` is NOT valid" do
          context "when `name` is `nil`" do
            let(:name) { nil }

            it "returns `failure` with `message`" do
              expect(result).to be_failure.with_data(name: "Name is `nil`").of_service(described_class).of_step(:validate_name)
            end
          end

          context "when `name` is empty" do
            let(:name) { "" }

            it "returns `failure` with `message`" do
              expect(result).to be_failure.with_data(name: "Name is empty").of_service(described_class).of_step(:validate_name)
            end
          end
        end

        context "when node is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertNodeAvailable).to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertNodeAvailable)
          end
        end

        context "when npm package is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Standard::V1::Gemfile::Services::AssertNodeAvailable)
              .to return_success

            stub_service(ConvenientService::Examples::Standard::V1::Gemfile::Services::RunShellCommand)
              .with_arguments(command: npm_package_available_command)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::V1::Gemfile::Services::RunShellCommand)
          end
        end
      end

      context "when `AssertNpmPackageAvailable` is successful" do
        before do
          stub_service(ConvenientService::Examples::Standard::V1::Gemfile::Services::RunShellCommand)
            .with_arguments(command: npm_package_available_command)
            .to return_success
        end

        it "returns `success`" do
          expect(result).to be_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::V1::Gemfile::Services::RunShellCommand)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

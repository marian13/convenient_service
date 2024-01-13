# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

return unless defined? ConvenientService::Examples::Dry

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertNpmPackageAvailable do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Examples::Dry::V1::Gemfile::DryService::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result(name: name) }

      let(:name) { "strip-comments" }
      let(:npm_package_available_command) { "npm list #{name} --depth=0 > /dev/null 2>&1" }

      context "when `AssertNpmPackageAvailable` is NOT successful" do
        if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations?
          context "when `name` is NOT valid" do
            context "when `name` is NOT present" do
              let(:name) { "" }

              it "returns `error` with `message`" do
                expect(result).to be_error.with_message("name can't be blank").of_service(described_class).without_step
              end
            end
          end
        end

        context "when node is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertNodeAvailable).to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertNodeAvailable)
          end
        end

        context "when npm package is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::AssertNodeAvailable)
              .to return_success

            stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::RunShellCommand)
              .with_arguments(command: npm_package_available_command)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Dry::V1::Gemfile::Services::RunShellCommand)
          end
        end
      end

      context "when `AssertNpmPackageAvailable` is successful" do
        before do
          stub_service(ConvenientService::Examples::Dry::V1::Gemfile::Services::RunShellCommand)
            .with_arguments(command: npm_package_available_command)
            .to return_success
        end

        it "returns `success`" do
          expect(result).to be_success.of_service(described_class).of_step(ConvenientService::Examples::Dry::V1::Gemfile::Services::RunShellCommand)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

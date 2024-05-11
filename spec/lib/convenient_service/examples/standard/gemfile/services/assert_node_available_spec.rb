# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable, type: :standard do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { described_class.result }

      let(:node_available_command) { "which node > /dev/null 2>&1" }

      context "when `AssertNodeAvailable` is NOT successful" do
        context "when node is NOT available" do
          before do
            stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand)
              .with_arguments(command: node_available_command)
              .to return_error
          end

          it "returns intermediate step result" do
            expect(result).to be_not_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand)
          end
        end
      end

      context "when `AssertNodeAvailable` is successful" do
        before do
          stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand)
            .with_arguments(command: node_available_command)
            .to return_success
        end

        it "returns `success`" do
          expect(result).to be_success.of_service(described_class).of_step(ConvenientService::Examples::Standard::Gemfile::Services::RunShellCommand)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

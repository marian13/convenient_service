# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

RSpec.describe ConvenientService::Examples::Standard::Gemfile::Services::AssertNodeAvailable do
  include ConvenientService::RSpec::Helpers::StubService
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:service) { described_class.new }

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  describe "#result" do
    subject(:result) { service.result }

    let(:node_available_command) { "which node > /dev/null 2>&1" }

    before do
      stub_service(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
        .with_arguments(command: node_available_command)
        .to return_result(node_available_status)
    end

    context "when node is NOT available" do
      let(:node_available_status) { :error }

      it "returns intermediate step result" do
        expect(result).to be_not_success.of(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
      end
    end

    context "when node is available" do
      let(:node_available_status) { :success }

      it "returns success" do
        expect(result).to be_success.of(ConvenientService::Examples::Standard::Gemfile::Services::RunShell)
      end
    end
  end
end

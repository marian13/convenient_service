# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups
RSpec.describe ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      context "when `FailureService` is NOT successful" do
        context "when `message` is NOT passed" do
          subject(:result) { described_class.result }

          let(:default_message) { "foo" }

          it "returns `failure` with `default message`" do
            expect(result).to be_failure.with_message(default_message).of_service(described_class).without_step
          end
        end
      end

      context "when `message` is passed" do
        subject(:result) { described_class.result(message: message) }

        let(:message) { "bar" }

        it "returns `failure` with that passed `message`" do
          expect(result).to be_failure.with_message(message).of_service(described_class).without_step
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups

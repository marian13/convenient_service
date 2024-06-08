# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
return unless defined? ConvenientService::Examples::Standard

RSpec.describe ConvenientService::Examples::Standard::ComprehensiveSuite::Services::ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps, type: :standard do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::IncludeModule

  example_group "modules" do
    subject { described_class }

    it { is_expected.to include_module(ConvenientService::Standard::Config) }
  end

  example_group "class methods" do
    describe ".result" do
      subject(:result) { service.result }

      let(:service) { described_class.new(out: out) }

      let(:out) { Tempfile.new }

      context "when `ServiceWithAllTypesOfSteps` is successful" do
        it "returns `success`" do
          expect(result).to be_failure.with_data(index: 10).of_service(described_class).of_step(ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService)
        end

        example_group "logs" do
          let(:actual_output) { out.tap(&:rewind).read }

          let(:expected_output) do
            <<~TEXT
              Started service `#{described_class}`.
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService` (steps[0]).
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService` (steps[2]).
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService` (steps[4]).
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService` (steps[6]).
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService` (steps[8]).
                Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService` (steps[10]).
              Completed service `#{described_class}`.
            TEXT
          end

          before do
            allow(service).to receive(:puts).and_call_original
          end

          it "prints progress bar after each step" do
            result

            expect(actual_output).to eq(expected_output)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
RSpec.describe ConvenientService::Examples::Standard::ComprehensiveSuite::Services::ServiceWithAllTypesOfSteps do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo
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

      let(:actual_output) { out.tap(&:rewind).read }

      let(:expected_output) do
        <<~TEXT
          Started service `#{described_class}`.
            Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService` (steps[0]).
            Run step `:failure_method` (steps[1]).
            Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService` (steps[2]).
            Run step `:success_method` (steps[3]).
            Run step `ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService` (steps[4]).
            Run step `:failure_method` (steps[5]).
          Completed service `#{described_class}`.
        TEXT
      end

      context "when `ServiceWithAllTypesOfSteps` is successful" do
        before do
          allow(service).to receive(:puts).and_call_original
        end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService, :result)
            .with_arguments(index: 0)
        end

        ##
        # TODO: Implement a way to check delegation to method step.
        # TODO: Implement a way to pass overridden arguments to method step.
        #
        # specify do
        #   expect { result }
        #     .to delegate_to(service.steps[1], :result)
        #     .with_arguments(index: 1)
        # end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::ComprehensiveSuite::Services::SuccessService, :result)
            .with_arguments(index: 2)
        end

        ##
        # TODO: Implement a way to check delegation to method step.
        # TODO: Implement a way to pass overridden arguments to method step.
        #
        # specify do
        #   expect { result }
        #     .to delegate_to(service.steps[3], :result)
        #     .with_arguments(index: 3)
        # end

        specify do
          expect { result }
            .to delegate_to(ConvenientService::Examples::Standard::ComprehensiveSuite::Services::FailureService, :result)
            .with_arguments(index: 4)
        end

        ##
        # TODO: Implement a way to check delegation to method step.
        # TODO: Implement a way to pass overridden arguments to method step.
        #
        # specify do
        #   expect { result }
        #     .to delegate_to(service.steps[5], :result)
        #     .with_arguments(index: 5)
        # end

        ##
        # FIX: Modify copy of original result to create negated result.
        #
        # it "returns `success`" do
        #   expect(result).to be_success.of_service(described_class).of_step(:failure_method)
        # end

        it "prints progress bar after each step" do
          result

          expect(actual_output).to eq(expected_output)
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers

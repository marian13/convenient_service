# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Service with all types of steps", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results
  include ConvenientService::RSpec::Matchers::DelegateTo
  include ConvenientService::RSpec::Matchers::IncludeModule

  let(:services) do
    services = {}

    services[:ErrorService] = Class.new do
      include ConvenientService::Standard::Config

      ##
      # @!attribute [r] index
      #   @return [Integer]
      #
      attr_reader :index

      ##
      # @param index [Integer]
      # @return [void]
      #
      def initialize(index: -1)
        @index = index
      end

      ##
      # @return [ConvenientService::Result]
      #
      def result
        error(index: index)
      end

      def self.name
        "ErrorService"
      end
    end

    services[:FailureService] = Class.new do
      include ConvenientService::Standard::Config

      ##
      # @!attribute [r] index
      #   @return [Integer]
      #
      attr_reader :index

      ##
      # @param index [Integer]
      # @return [void]
      #
      def initialize(index: -1)
        @index = index
      end

      ##
      # @return [ConvenientService::Result]
      #
      def result
        failure(index: index)
      end

      def self.name
        "FailureService"
      end
    end

    services[:SuccessService] = Class.new do
      include ConvenientService::Standard::Config

      ##
      # @!attribute [r] index
      #   @return [Integer]
      #
      attr_reader :index

      ##
      # @param index [Integer]
      # @return [void]
      #
      def initialize(index: -1)
        @index = index
      end

      ##
      # @return [ConvenientService::Result]
      #
      def result
        success(index: index)
      end

      def self.name
        "SuccessService"
      end
    end

    services[:ServiceWithAllTypesOfSteps] = Class.new.tap do |klass|
      klass.class_exec(services) do |services|
        include ConvenientService::Standard::Config

        attr_reader :out

        ##
        # TODO: Add support of the single hash with multiple inputs.
        #
        step services[:SuccessService],
          in: {index: -> { 0 }}

        not_step :failure_method,
          in: {index: -> { 1 }}

        and_step services[:SuccessService],
          in: {index: -> { 2 }}

        and_not_step :success_method,
          in: {index: -> { 3 }}

        or_step services[:FailureService],
          in: {index: -> { 4 }}

        or_not_step :failure_method,
          in: {index: -> { 5 }}

        before :result do
          puts "Started service `#{self.class.name}`."
        end

        after :result do
          puts "Completed service `#{self.class.name}`."
        end

        after :step do |step|
          puts "  Run step `#{step}` (steps[#{step.index}])."
        end

        def initialize(out: $stdout)
          @out = out
        end

        private

        def success_method(index:)
          success(index: index)
        end

        def failure_method(index:)
          failure(index: index)
        end

        def puts(...)
          out.puts(...)
        end

        def self.name
          "ServiceWithAllTypesOfSteps"
        end
      end
    end

    services
  end

  example_group "Service" do
    example_group "instance methods" do
      describe "#result" do
        subject(:result) { service.result }

        let(:service) { services[:ServiceWithAllTypesOfSteps].new(out: out) }

        let(:out) { Tempfile.new }

        context "when `ServiceWithAllTypesOfSteps` is successful" do
          specify do
            expect { result }
              .to delegate_to(services[:SuccessService], :result)
              .with_arguments(index: 0)
          end

          ##
          # TODO: Implement a way to check delegation to method step.
          #
          # specify do
          #   expect { result }
          #     .to delegate_to(service.steps[1], :result)
          #     .with_arguments(index: 1)
          # end

          specify do
            expect { result }
              .to delegate_to(services[:SuccessService], :result)
              .with_arguments(index: 2)
          end

          ##
          # TODO: Implement a way to check delegation to method step.
          #
          # specify do
          #   expect { result }
          #     .to delegate_to(service.steps[3], :result)
          #     .with_arguments(index: 3)
          # end

          specify do
            expect { result }
              .to delegate_to(services[:FailureService], :result)
              .with_arguments(index: 4)
          end

          ##
          # TODO: Implement a way to check delegation to method step.
          #
          # specify do
          #   expect { result }
          #     .to delegate_to(service.steps[5], :result)
          #     .with_arguments(index: 5)
          # end

          ##
          # TODO: `of_step`, `of_not_step`, `of_and_step`, `of_or_step`, `of_not_or_step`? Or generic `of_step(step, with: type)?`
          #
          it "returns `success`" do
            expect(result).to be_success.with_data(index: 5).of_service(services[:ServiceWithAllTypesOfSteps]).of_step(:failure_method)
          end

          example_group "logs" do
            let(:actual_output) { out.tap(&:rewind).read }

            let(:expected_output) do
              <<~TEXT
                Started service `ServiceWithAllTypesOfSteps`.
                  Run step `SuccessService` (steps[0]).
                  Run step `:failure_method` (steps[1]).
                  Run step `SuccessService` (steps[2]).
                  Run step `:success_method` (steps[3]).
                  Run step `FailureService` (steps[4]).
                  Run step `:failure_method` (steps[5]).
                Completed service `ServiceWithAllTypesOfSteps`.
              TEXT
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
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass

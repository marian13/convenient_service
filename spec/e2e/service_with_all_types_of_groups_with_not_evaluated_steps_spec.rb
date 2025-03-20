# frozen_string_literal: true

require "spec_helper"

require "convenient_service"

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass
RSpec.describe "Service with all types of groups with NOT evaluated steps", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results
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

    services[:ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps] = Class.new.tap do |klass|
      klass.class_exec(services) do |services|
        include ConvenientService::Standard::Config

        attr_reader :out

        group do
          step services[:SuccessService],
            in: {index: -> { 0 }}

          or_step :error_method,
            in: {index: -> { 1 }}
        end

        not_group do
          step services[:FailureService],
            in: {index: -> { 2 }}

          and_step :failure_method,
            in: {index: -> { 3 }}
        end

        and_group do
          not_step services[:FailureService],
            in: {index: -> { 4 }}

          or_step :success_method,
            in: {index: -> { 5 }}
        end

        and_not_group do
          not_step services[:FailureService],
            in: {index: -> { 6 }}

          or_step :success_method,
            in: {index: -> { 7 }}
        end

        or_group do
          not_step services[:SuccessService],
            in: {index: -> { 8 }}

          and_not_step services[:ErrorService],
            in: {index: -> { 9 }}
        end

        or_not_group do
          not_step services[:FailureService],
            in: {index: -> { 10 }}

          or_not_step :success_method,
            in: {index: -> { 11 }}
        end

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

        def error_method(index:)
          error(index: index)
        end

        def puts(...)
          out.puts(...)
        end

        def self.name
          "ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps"
        end
      end
    end

    services
  end

  example_group "Service" do
    example_group "instance methods" do
      describe "#result" do
        subject(:result) { service.result }

        let(:service) { services[:ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps].new(out: out) }

        let(:out) { Tempfile.new }

        context "when `ServiceWithAllTypesOfSteps` is successful" do
          it "returns `success`" do
            expect(result).to be_failure.with_data(index: 10).of_service(services[:ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps]).of_step(services[:FailureService])
          end

          example_group "logs" do
            let(:actual_output) { out.tap(&:rewind).read }

            let(:expected_output) do
              <<~TEXT
                Started service `ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps`.
                  Run step `SuccessService` (steps[0]).
                  Run step `FailureService` (steps[2]).
                  Run step `FailureService` (steps[4]).
                  Run step `FailureService` (steps[6]).
                  Run step `SuccessService` (steps[8]).
                  Run step `FailureService` (steps[10]).
                Completed service `ServiceWithAllTypesOfGroupsWithNotEvaluatedSteps`.
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

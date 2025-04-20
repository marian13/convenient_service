# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

# rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations, Style/RedundantLineContinuation
RSpec.describe "If steps", type: [:standard, :e2e] do
  include ConvenientService::RSpec::Matchers::Results

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

    services
  end

  let(:concern) do
    Module.new.tap do |mod|
      mod.module_exec(services) do |services|
        include ConvenientService::Concern

        included do
          attr_reader :out

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

          def services
            self.class.services
          end

          def puts(...)
            out.puts(...)
          end
        end

        class_methods do
          def name
            "Service"
          end
        end

        self::ClassMethods.define_method(:services) { services }
      end
    end
  end

  let(:out) { Tempfile.new }

  let(:result) { service.result(out: out) }

  let(:actual_output) { out.tap(&:rewind).read }

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 2 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:success_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `FailureService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:success_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `FailureService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:SuccessService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `SuccessService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :success_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:success_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:success_method` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[4]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `FailureService` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:failure_method` (steps[2]).
            Run step `SuccessService` (steps[3]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `ErrorService` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `:error_method` (steps[2]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:FailureService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `FailureService` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :failure_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_success

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:failure_method` (steps[0]).
            Run step `SuccessService` (steps[1]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:SuccessService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :success_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:FailureService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :failure_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group services[:ErrorService],
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group services[:ErrorService],
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `ErrorService` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  context do
    let(:service) do
      Class.new.tap do |klass|
        klass.class_exec(concern) do |concern|
          include ConvenientService::Standard::Config
          include concern

          if_not_step_group :error_method,
            in: [index: -> { 0 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 1 }]
          end

          elsif_not_step_group :error_method,
            in: [index: -> { 2 }] \
          do
            step services[:SuccessService],
              in: [index: -> { 3 }]
          end

          else_group do
            step services[:SuccessService],
              in: [index: -> { 4 }]
          end
        end
      end
    end

    specify do
      expect(result).to be_error

      expect(actual_output).to eq(
        <<~TEXT
          Started service `Service`.
            Run step `:error_method` (steps[0]).
          Completed service `Service`.
        TEXT
      )
    end
  end

  ##
  # TODO: Group specs.
  # TODO: Exceptions specs.
  # TODO: With regular specs.
  # TODO: Sync result with queries.
  ##
end
# rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers, RSpec/DescribeClass, RSpec/ExampleLength, RSpec/MissingExampleGroupArgument, RSpec/MultipleExpectations, Style/RedundantLineContinuation

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

    services[:SuccessService] = Class.new do
      include ConvenientService::Standard::Config

      ##
      # @!attribute [r] original_method
      #   @return [String]
      #
      attr_reader :original_method

      ##
      # @param original_method [String]
      # @return [void]
      #
      def initialize(original_method: nil)
        @original_method = original_method
      end

      ##
      # @return [ConvenientService::Result]
      #
      def result
        success(original_method: original_method)
      end

      ##
      # @return [String]
      #
      def self.name
        "SuccessService"
      end
    end

    services[:ServiceWithAllTypesOfInputs] = Class.new.tap do |klass|
      klass.class_exec(services) do |services|
        include ConvenientService::Standard::Config

        attr_reader :out

        class << self
          def service_class_method
            :service_class_method_value
          end
        end

        step services[:SuccessService]

        step services[:SuccessService],
          in: []

        step services[:SuccessService],
          in: :original_method

        step services[:SuccessService],
          in: [:original_method]

        step services[:SuccessService],
          in: "original_method"

        step services[:SuccessService],
          in: ["original_method"]

        step services[:SuccessService],
          in: {original_method: :alias_method}

        step services[:SuccessService],
          in: [{original_method: :alias_method}]

        step services[:SuccessService],
          in: [original_method: :alias_method]

        step services[:SuccessService],
          in: {original_method: "alias_method"}

        step services[:SuccessService],
          in: [{original_method: "alias_method"}]

        step services[:SuccessService],
          in: [original_method: "alias_method"]

        step services[:SuccessService],
          in: {original_method: raw(service_class_method)}

        step services[:SuccessService],
          in: [{original_method: raw(service_class_method)}]

        step services[:SuccessService],
          in: [original_method: raw(service_class_method)]

        step services[:SuccessService],
          in: {original_method: -> { service_instance_method }}

        step services[:SuccessService],
          in: [{original_method: -> { service_instance_method }}]

        step services[:SuccessService],
          in: {original_method: -> { service_instance_method }}

        before :result do
          puts "Started service `#{self.class.name}`."
        end

        after :result do
          puts "Completed service `#{self.class.name}`."
        end

        after :step do |step|
          puts "  Run step `#{step}` (inputs: [#{step.inputs.map { |input| "#{input.key.value.inspect} => #{input.value.inspect}" }.join(", ")}])."
        end

        def initialize(out: $stdout)
          @out = out
        end

        private

        def original_method
          :original_method_value
        end

        def alias_method
          :alias_method_value
        end

        def service_instance_method
          :service_instance_method_value
        end

        def puts(...)
          out.puts(...)
        end

        def self.name
          "ServiceWithAllTypesOfInputs"
        end
      end
    end

    services
  end

  example_group "Service" do
    example_group "instance methods" do
      describe "#result" do
        subject(:result) { service.result }

        let(:service) { services[:ServiceWithAllTypesOfInputs].new(out: out) }

        let(:out) { Tempfile.new }

        context "when `ServiceWithAllTypesOfInputs` is successful" do
          it "returns `success`" do
            expect(result).to be_success.of_service(services[:ServiceWithAllTypesOfInputs]).of_step(services[:SuccessService])
          end

          example_group "logs" do
            let(:actual_output) { out.tap(&:rewind).read }

            let(:expected_output) do
              <<~TEXT
                Started service `ServiceWithAllTypesOfInputs`.
                  Run step `SuccessService` (inputs: []).
                  Run step `SuccessService` (inputs: []).
                  Run step `SuccessService` (inputs: [:original_method => :original_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :original_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :original_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :original_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :alias_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_class_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_class_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_class_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_instance_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_instance_method_value]).
                  Run step `SuccessService` (inputs: [:original_method => :service_instance_method_value]).
                Completed service `ServiceWithAllTypesOfInputs`.
              TEXT
            end

            it "prints logs after each step" do
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

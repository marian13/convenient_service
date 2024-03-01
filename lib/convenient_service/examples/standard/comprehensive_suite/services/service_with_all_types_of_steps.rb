# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        module Services
          class ServiceWithAllTypesOfSteps
            include ConvenientService::Standard::Config

            attr_reader :out

            ##
            # TODO: Add support of the single hash with multiple inputs.
            #
            step SuccessService,
              in: {index: -> { 0 }}

            not_step :failure_method,
              in: {index: -> { 1 }}

            and_step SuccessService,
              in: {index: -> { 2 }}

            and_not_step :success_method,
              in: {index: -> { 3 }}

            or_step FailureService,
              in: {index: -> { 4 }}

            or_not_step :failure_method,
              in: {index: -> { 5 }}

            before :result do
              puts "Started service `#{self.class}`."
            end

            after :result do
              puts "Completed service `#{self.class}`."
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
          end
        end
      end
    end
  end
end

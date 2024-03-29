# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        module Services
          class ServiceWithAllTypesOfGroups
            include ConvenientService::Standard::Config

            attr_reader :out

            group do
              step SuccessService,
                in: {index: -> { 0 }}

              and_step :success_method,
                in: {index: -> { 1 }}
            end

            not_group do
              step SuccessService,
                in: {index: -> { 2 }}

              and_step :failure_method,
                in: {index: -> { 3 }}
            end

            and_group do
              not_step FailureService,
                in: {index: -> { 4 }}

              and_step :success_method,
                in: {index: -> { 5 }}
            end

            and_not_group do
              step FailureService,
                in: {index: -> { 6 }}

              or_step :success_method,
                in: {index: -> { 7 }}
            end

            or_group do
              step FailureService,
                in: {index: -> { 8 }}

              or_not_step :success_method,
                in: {index: -> { 9 }}
            end

            or_not_group do
              step SuccessService,
                in: {index: -> { 10 }}

              and_not_step :success_method,
                in: {index: -> { 11 }}
            end

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

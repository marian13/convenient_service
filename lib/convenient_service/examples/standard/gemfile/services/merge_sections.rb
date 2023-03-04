# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class MergeSections
            include ConvenientService::Standard::Config

            ##
            # IMPORTANT:
            #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
            #   - It will be reenabled after the introduction of thread-safety specs.
            #   - Do not use it in production yet.
            #
            middlewares :step, scope: :class do
              use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
            end

            attr_reader :header, :body

            step :validate_header,
              in: :header

            step :validate_body,
              in: :body

            step :result,
              in: [
                :header,
                :body
              ]

            def initialize(header:, body:)
              @header = header
              @body = body
            end

            def result
              success(merged_sections: "#{header}\n#{body}")
            end

            def validate_header
              return failure(header: "Header is `nil`") if header.nil?
              return failure(header: "Header is empty") if header.empty?

              success
            end

            def validate_body
              return failure(body: "Body is `nil`") if body.nil?
              return failure(body: "Body is empty") if body.empty?

              success
            end
          end
        end
      end
    end
  end
end

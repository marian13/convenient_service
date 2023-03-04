# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class ReadFileContent
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

            attr_reader :path

            step :validate_path
            step Services::AssertFileExists, in: :path
            step Services::AssertFileNotEmpty, in: :path
            step :result, in: :path, out: :content

            def initialize(path:)
              @path = path
            end

            def result
              success(data: {content: ::File.read(path)})
            end

            private

            def validate_path
              return failure(path: "Path is `nil`") if path.nil?
              return failure(path: "Path is empty") if path.empty?

              success
            end
          end
        end
      end
    end
  end
end

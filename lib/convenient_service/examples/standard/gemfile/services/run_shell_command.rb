# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class Gemfile
        module Services
          class RunShellCommand
            include ConvenientService::Standard::Config

            attr_reader :command, :debug

            step :validate_command,
              in: :command

            step Services::PrintShellCommand,
              in: [:command, {skip: -> { !debug }}],
              fallback: true

            step :result,
              in: :command

            def initialize(command:, debug: false)
              @command = command
              @debug = debug
            end

            def result
              ##
              # NOTE: When the command exit code is 0, `system` return `true`, and `false` otherwise.
              # - https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-system
              # - https://stackoverflow.com/a/37329716/12201472
              #
              if system(command)
                success
              else
                error("#{command} returned non-zero exit code")
              end
            end

            private

            def validate_command
              return error("Command is `nil`") if command.nil?
              return error("Command is empty") if command.empty?

              success
            end
          end
        end
      end
    end
  end
end

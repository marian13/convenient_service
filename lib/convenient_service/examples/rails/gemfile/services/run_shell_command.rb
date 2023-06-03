# frozen_string_literal: true

module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class RunShellCommand
            include RailsService::Config

            attribute :command, :string
            attribute :debug, :boolean, default: false

            validates :command, presence: true if ConvenientService::Dependencies.support_has_result_params_validations_using_active_model_validations?

            step Services::PrintShellCommand,
              in: [:command, {skip: -> { !debug }}],
              try: true

            step :result,
              in: :command

            def result
              ##
              # NOTE: When the command exit code is 0, `system` return `true`, and `false` otherwise.
              # - https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-system
              # - https://stackoverflow.com/a/37329716/12201472
              #
              if system(command)
                success
              else
                error(message: "#{command} returned non-zero exit code")
              end
            end
          end
        end
      end
    end
  end
end

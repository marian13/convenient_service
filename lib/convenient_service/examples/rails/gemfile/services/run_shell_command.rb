# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class RunShellCommand
            include RailsService::Config

            attribute :command, :string
            attribute :debug, :boolean, default: false

            validates :command, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            step Services::PrintShellCommand,
              in: [:command, {skip: -> { !debug }}],
              fallback: true

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
                error("#{command} returned non-zero exit code")
              end
            end
          end
        end
      end
    end
  end
end

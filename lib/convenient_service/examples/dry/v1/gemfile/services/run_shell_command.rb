# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Dry
      module V1
        class Gemfile
          module Services
            class RunShellCommand
              include DryService::Config

              option :command
              option :debug, default: -> { false }

              contract do
                schema do
                  required(:command).filled(:string)
                  optional(:debug).value(:bool)
                end
              end

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
end

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Usage example:
#
#   ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand.result(command: "ls -a")
#
module ConvenientService
  module Examples
    module Rails
      class Gemfile
        module Services
          class PrintShellCommand
            include RailsService::Config

            attribute :command, :string
            attribute :skip, :boolean, default: false
            attribute :out, default: $stdout

            validates :command, presence: true if ConvenientService::Dependencies.support_has_j_send_result_params_validations_using_active_model_validations_plugin?

            def result
              return failure("Printing of shell command `#{command}` is skipped") if skip

              out.puts

              out.puts ::Paint["$ #{command}", :blue, :bold]

              success
            end

            def fallback_result
              success
            end
          end
        end
      end
    end
  end
end

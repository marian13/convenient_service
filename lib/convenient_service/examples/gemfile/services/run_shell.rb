# frozen_string_literal: true

module ConvenientService
  module Examples
    module Gemfile
      module Services
        class RunShell
          include ConvenientService::Configs::Rails

          attribute :command, :string
          attribute :debug, :boolean, default: false

          validates :command, presence: true

          def result
            Services::PrintShellCommand.result(text: command) if debug

            ##
            # NOTE: When the command exit code is 0, `system' return true, and false otherwise.
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

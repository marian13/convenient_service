# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Rails::Gemfile::Services::PrintShellCommand.result(text: "ls -a")
#
module ConvenientService
  module Examples
    module Rails
      module Gemfile
        module Services
          class PrintShellCommand
            include RailsService::Config

            attribute :text, :string
            attribute :out, default: $stdout

            validates :text, presence: true if ConvenientService::Dependencies.support_has_result_params_validations_using_active_model_validations?

            def result
              out.puts

              out.puts ::Paint["$ #{text}", :blue, :bold]

              success
            end
          end
        end
      end
    end
  end
end

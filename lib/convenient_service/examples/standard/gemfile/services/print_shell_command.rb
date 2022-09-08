# frozen_string_literal: true

##
# Usage example:
#
#   ConvenientService::Examples::Standard::Gemfile::Services::PrintShellCommand.result(text: "ls -a")
#
module ConvenientService
  module Examples
    module Standard
      module Gemfile
        module Services
          class PrintShellCommand
            include ConvenientService::Configs::Standard

            include ConvenientService::Configs::AssignsAttributesInConstructor::UsingActiveModelAttributeAssignment
            include ConvenientService::Configs::HasAttributes::UsingActiveModelAttributes
            include ConvenientService::Configs::HasResultParamsValidations::UsingActiveModelValidations

            attribute :text, :string
            attribute :out, default: $stdout

            validates :text, presence: true

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

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "code/commands"

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            module Entities
              class Code
                ##
                # @api private
                #
                # @!attribute flowchart [r]
                #   @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart]
                #
                attr_reader :flowchart

                ##
                # @api private
                #
                # @return [void]
                #
                def initialize(flowchart:)
                  @flowchart = flowchart
                end

                ##
                # @api private
                #
                # @return [String]
                #
                # @example Generated code for a service with steps, but without nested steps.
                #
                #   flowchart LR
                #     7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-validate_path[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent#validate_path]
                #     7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-7920[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists]
                #     7900-7920[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists] --> 7900-7920-result[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists#result]
                #     7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-7940[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty]
                #     7900-7940[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty] --> 7900-7940-result[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty#result]
                #     7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-result[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent#result]
                #
                def generate
                  lines.join("\n")
                end

                ##
                # @api private
                #
                # @return [String]
                #
                # @example Generated code for a service with steps, but without nested steps.
                #
                #   [
                #     "flowchart LR",
                #     "  7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-validate_path[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent#validate_path]",
                #     "  7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-7920[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists]",
                #     "  7900-7920[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists] --> 7900-7920-result[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileExists#result]",
                #     "  7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-7940[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty]",
                #     "  7900-7940[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty] --> 7900-7940-result[ConvenientService::Examples::Standard::Gemfile::Services::AssertFileNotEmpty#result]",
                #     "  7900[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent] --> 7900-result[ConvenientService::Examples::Standard::Gemfile::Services::ReadFileContent#result]"
                #   ]
                #
                def lines
                  Commands::GenerateLines[code: self]
                end

                ##
                # @api private
                #
                # @param other [Object]
                # @return [Boolean, nil]
                #
                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if flowchart != other.flowchart

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end

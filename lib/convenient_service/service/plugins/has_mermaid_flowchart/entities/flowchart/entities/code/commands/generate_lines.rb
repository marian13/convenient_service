# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            module Entities
              class Code
                module Commands
                  class GenerateLines < Support::Command
                    include Support::Delegate

                    ##
                    # @api private
                    #
                    # @!attribute code [r]
                    #   @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Code]
                    #
                    attr_reader :code

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart]
                    #
                    delegate :flowchart, to: :code

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service]
                    #
                    delegate :service, to: :flowchart

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Settings]
                    #
                    delegate :settings, to: :flowchart

                    ##
                    # @api private
                    #
                    # @param code [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Code]
                    # @return [void]
                    #
                    def initialize(code:)
                      @code = code
                    end

                    ##
                    # @api private
                    #
                    # @return [Array<String>]
                    #
                    def call
                      [first_line, *service_lines]
                    end

                    private

                    ##
                    # @return [String]
                    #
                    # @internal
                    #   NOTE: Flowchart docs.
                    #   - https://mermaid.js.org/syntax/flowchart.html
                    #
                    def first_line
                      <<~MERMAID.chomp
                        flowchart #{settings.direction}
                      MERMAID
                    end

                    ##
                    # @return [Array<String>]
                    #
                    def service_lines
                      GenerateServiceLines[service: service, ids: [], settings: settings]
                        .map { |line| "  #{line}" }
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

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
                  class GenerateResultLines < Support::Command
                    ##
                    # @api private
                    #
                    # @!attribute service [r]
                    #   @return [ConvenientService::Service]
                    #
                    attr_reader :service

                    ##
                    # @api private
                    #
                    # @!attribute ids [r]
                    #   @return [Array<String>]
                    #
                    attr_reader :ids

                    ##
                    # @api private
                    #
                    # @!attribute settings [r]
                    #   @return [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Settings]
                    #
                    attr_reader :settings

                    ##
                    # @api private
                    #
                    # @param service [ConvenientService::Service]
                    # @param ids [Array<String>]
                    # @param settings [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Settings]
                    # @return [void]
                    #
                    def initialize(service:, ids:, settings:)
                      @service = service
                      @ids = ids
                      @settings = settings
                    end

                    ##
                    # @api private
                    #
                    # @return [Array<String>]
                    #
                    def call
                      [
                        <<~MERMAID.chomp
                          #{service_id}[#{service_name}] --> #{result_id}[#{result_name}]
                        MERMAID
                      ]
                    end

                    private

                    ##
                    # @return [String]
                    #
                    # @internal
                    #   TODO: Entities::ID.
                    #
                    def service_id
                      ids.join("-")
                    end

                    ##
                    # @return [String]
                    #
                    def service_name
                      Utils::Class.display_name(service)
                    end

                    ##
                    # @return [String]
                    #
                    def result_id
                      "#{service_id}-result"
                    end

                    ##
                    # @return [String]
                    #
                    def result_name
                      "#{service_name}#result"
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

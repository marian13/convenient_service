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
                  class GenerateMethodStepLines < Support::Command
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
                    # @!attribute step [r]
                    #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    #
                    attr_reader :step

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
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @param ids [Array<String>]
                    # @param settings [ConvenientService::Service::Plugins::HasMermaidFlowchart::Entities::Flowchart::Entities::Settings]
                    # @return [void]
                    #
                    def initialize(service:, step:, ids:, settings:)
                      @service = service
                      @step = step
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
                          #{service_id}[#{service_name}] --> #{method_step_id}[#{method_step_name}]
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
                    def method_step_id
                      "#{service_id}-#{step.method}"
                    end

                    ##
                    # @return [String]
                    #
                    def method_step_name
                      "#{service_name}##{step.method}"
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

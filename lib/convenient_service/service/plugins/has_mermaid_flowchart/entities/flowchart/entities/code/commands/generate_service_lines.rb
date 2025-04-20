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
                  class GenerateServiceLines < Support::Command
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
                      return Commands::GenerateResultLines[service: service, settings: settings, ids: next_ids] if service.steps.none?

                      service.steps.flat_map do |step|
                        if step.method_step?
                          Commands::GenerateMethodStepLines[service: service, settings: settings, step: step, ids: next_ids]
                        else
                          Commands::GenerateServiceStepLines[service: service, settings: settings, step: step, ids: next_ids]
                        end
                      end
                    end

                    private

                    ##
                    # @return [Array<String>]
                    #
                    # @internal
                    #   TODO: Entities::ID.
                    #
                    def next_ids
                      @next_ids ||= ids + [service.object_id]
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

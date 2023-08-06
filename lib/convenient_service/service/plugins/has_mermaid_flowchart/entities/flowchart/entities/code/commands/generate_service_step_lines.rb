# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasMermaidFlowchart
        module Entities
          class Flowchart
            module Entities
              class Code
                module Commands
                  class GenerateServiceStepLines < Support::Command
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
                    # @return [String]
                    #
                    def call
                      [step_service_line, *sub_service_lines]
                    end

                    private

                    ##
                    # @return [String]
                    #
                    def step_service_line
                      <<~MERMAID.chomp
                        #{service_id}[#{service_name}] --> #{service_step_id}[#{service_step_name}]
                      MERMAID
                    end

                    ##
                    # @return [String]
                    #
                    def sub_service_lines
                      Commands::GenerateServiceLines[service: step.service.klass, ids: ids, settings: settings]
                    end

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
                    def service_step_id
                      "#{service_id}-#{step.service.klass.object_id}"
                    end

                    ##
                    # @return [String]
                    #
                    def service_step_name
                      Utils::Class.display_name(step.service.klass)
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

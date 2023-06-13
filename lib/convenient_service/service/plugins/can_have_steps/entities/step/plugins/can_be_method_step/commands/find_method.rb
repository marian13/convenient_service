# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module Commands
                  class FindMethod < Support::Command
                    ##
                    # @!attribute [r] step
                    #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    #
                    attr_reader :step

                    ##
                    # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
                    # @return [void]
                    #
                    def initialize(step:)
                      @step = step
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method, nil]
                    #
                    def call
                      return unless [Services::RunMethodInOrganizer, Services::RunOwnMethodInOrganizer].include?(step.service.klass)

                      step.inputs.find { |input| input.key.to_sym == :method_name }
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

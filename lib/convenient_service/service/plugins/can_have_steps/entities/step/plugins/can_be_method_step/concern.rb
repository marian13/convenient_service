# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method, nil]
                    #
                    def method
                      Commands::FindMethod.call(step: self)
                    end

                    ##
                    # @return [Boolean]
                    #
                    def method_step?
                      Utils.to_bool(method)
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

# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module HasInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    def inspect
                      return "<#{container.klass.name}::Step method: :#{method}>" if method_step?

                      "<#{container.klass.name}::Step service: #{service.klass.name}>"
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

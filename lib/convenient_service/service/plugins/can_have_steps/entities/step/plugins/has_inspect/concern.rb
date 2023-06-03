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
                    # @since 0.2.0
                    #
                    # @internal
                    #   TODO: What if result is created from method step?
                    #
                    def inspect
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

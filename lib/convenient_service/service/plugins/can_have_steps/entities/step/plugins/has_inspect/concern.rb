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
                    # @internal
                    #   TODO: `inspect_values` for class. This way `service_class.name || ...` can be shared.
                    #
                    def inspect
                      return "<#{container.klass.name}::Step method: :#{method}>" if method_step?
                      return "<#{container.klass.name}::Step service: #{service_class.name}>" if service_step?

                      "<#{container.klass.name}::Step>"
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

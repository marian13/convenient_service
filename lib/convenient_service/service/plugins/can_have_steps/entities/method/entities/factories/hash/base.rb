# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Factories
                module Hash
                  class Base < Factories::Base
                    ##
                    # @return [Symbol]
                    #
                    def key
                      @key ||= other.keys.first
                    end

                    ##
                    # @return [Object] Can be any object.
                    #
                    def value
                      @value ||= other.values.first
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

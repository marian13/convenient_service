# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Entities
        module Caches
          class Array < Caches::Base
            module Entities
              class NullPair < Entities::Pair
                ##
                # @return [void]
                #
                def initialize
                  @key = nil
                  @value = nil
                end

                ##
                # @param other_value [Object] Can be any type.
                # @return [Object] Can be any type.
                #
                def value=(other_value)
                  other_value
                end
              end
            end
          end
        end
      end
    end
  end
end

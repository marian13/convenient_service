# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class Type
            module ClassMethods
              def cast(other)
                case other
                when ::Symbol
                  Type.new(value: other)
                when ::String
                  Type.new(value: other.to_sym)
                when Type
                  Type.new(value: other.value)
                end
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Entities
              class Data
                module ClassMethods
                  def cast(other)
                    case other
                    when ::Hash
                      new(value: other.symbolize_keys)
                    when Data
                      new(value: other.value)
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

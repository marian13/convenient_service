# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Entities
              class Message
                module ClassMethods
                  def cast(other)
                    case other
                    when ::String
                      new(value: other)
                    when ::Symbol
                      new(value: other.to_s)
                    when Message
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

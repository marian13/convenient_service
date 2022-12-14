# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Entities
                  class Code
                    module ClassMethods
                      def cast(other)
                        case other
                        when ::String
                          new(value: other.to_sym)
                        when ::Symbol
                          new(value: other)
                        when Code
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
  end
end

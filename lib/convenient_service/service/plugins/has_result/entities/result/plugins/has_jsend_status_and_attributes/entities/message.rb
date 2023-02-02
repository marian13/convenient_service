# frozen_string_literal: true

require_relative "message/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Entities
                  class Message
                    include Support::Castable

                    extend ClassMethods

                    attr_reader :value

                    def initialize(value:)
                      @value = value
                    end

                    def ==(other)
                      casted = cast(other)

                      return unless casted

                      value == casted.value
                    end

                    def to_s
                      @to_s ||= value.to_s
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

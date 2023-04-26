# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Message
                    module Concern
                      module InstanceMethods
                        ##
                        # @!attribute [r] value
                        #   @return [String]
                        #
                        attr_reader :value

                        ##
                        # @param value [String]
                        # @return [void]
                        #
                        def initialize(value:)
                          @value = value
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          casted = cast(other)

                          return unless casted

                          value == casted.value
                        end

                        ##
                        # @return [String]
                        #
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
  end
end

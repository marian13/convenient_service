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
                    module Concern
                      module InstanceMethods
                        ##
                        # @!attribute [r] value
                        #   @return [Symbol]
                        #
                        attr_reader :value

                        ##
                        # @param value [Symbol]
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

                        ##
                        # @return [Symbol]
                        #
                        def to_sym
                          @to_sym ||= value.to_sym
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

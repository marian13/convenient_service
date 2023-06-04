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
                        include Support::Copyable

                        ##
                        # @!attribute [r] value
                        #   @return [String]
                        #
                        attr_reader :value

                        ##
                        # @!attribute [r] result
                        #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                        #
                        attr_reader :result

                        ##
                        # @param value [String]
                        # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                        # @return [void]
                        #
                        def initialize(value:, result: nil)
                          @value = value
                          @result = result
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          return unless other.instance_of?(self.class)

                          return false if result.class != other.result.class
                          return false if value != other.value

                          true
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        # @internal
                        #   IMPORTANT: Must be kept in sync with `#==`.
                        #   NOTE: Ruby does NOT have `!==` operator.
                        #
                        def ===(other)
                          return unless other.instance_of?(self.class)

                          return false if result.class != other.result.class
                          return false unless other.value === value

                          true
                        end

                        ##
                        # @return [Hash]
                        #
                        def to_kwargs
                          @to_kwargs ||= {value: value, result: result}
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

# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasStatusResponder
                module Entities
                  class UnexpectedHandler
                    ##
                    # @api private
                    #
                    # @!attribute [r] block
                    #   @return [Proc]
                    #
                    attr_reader :block

                    ##
                    # @api private
                    #
                    # @param block [Proc] Can be any type.
                    # @return [void]
                    #
                    def initialize(block:)
                      @block = block
                    end

                    ##
                    # @api private
                    #
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def handle
                      block.call(Support::Arguments.null_arguments)
                    end

                    ##
                    # @api private
                    #
                    # @api private
                    #
                    # @param other [Object] Can be any type.
                    # @return [Boolean, nil]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if block != other.block

                      true
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

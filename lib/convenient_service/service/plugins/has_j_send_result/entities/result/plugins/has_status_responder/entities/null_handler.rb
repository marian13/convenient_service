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
                  class NullHandler
                    ##
                    # @!attribute [r] block
                    #   @return [Proc]
                    #
                    attr_reader :block

                    ##
                    # @param block [Proc] Can be any type.
                    # @return [void]
                    #
                    def initialize(block:)
                      @block = block
                    end

                    ##
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def handle
                      block.call(Support::Arguments.null_arguments)
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

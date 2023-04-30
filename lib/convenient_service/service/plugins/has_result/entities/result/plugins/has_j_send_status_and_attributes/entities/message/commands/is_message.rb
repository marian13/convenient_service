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
                    module Commands
                      ##
                      # Check whether `message` can be considered as `Message` instance.
                      #
                      class IsMessage < Support::Command
                        ##
                        # @!attribute [r] message
                        #   @return [Object] Can be any type.
                        #
                        attr_reader :message

                        ##
                        # @param message [Object] Can be any type.
                        # @return [void]
                        #
                        def initialize(message:)
                          @message = message
                        end

                        ##
                        # @return [Boolean]
                        #
                        def call
                          message.class.include?(Entities::Message::Concern)
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

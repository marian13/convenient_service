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
                  class Handler
                    ##
                    # @!attribute [r] result
                    #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    attr_reader :result

                    ##
                    # @!attribute [r] status
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :status

                    ##
                    # @!attribute [r] data
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :data

                    ##
                    # @!attribute [r] message
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :message

                    ##
                    # @!attribute [r] code
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :code

                    ##
                    # @!attribute [r] block
                    #   @return [Proc]
                    #
                    attr_reader :block

                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @param status [Object] Can be any type.
                    # @param data [Object] Can be any type.
                    # @param message [Object] Can be any type.
                    # @param code [Object] Can be any type.
                    # @param block [Proc] Can be any type.
                    # @return [void]
                    #
                    def initialize(result:, status:, data:, message:, code:, block:)
                      @result = result
                      @status = status
                      @data = data
                      @message = message
                      @code = code
                      @block = block
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_status
                      @casted_status ||= result.create_status(status)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_data
                      @casted_data ||= result.create_data(data)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_message
                      @casted_message ||= result.create_message(message)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_code
                      @casted_code ||= result.create_code(code)
                    end

                    ##
                    # @return [Boolean]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def matches?
                      return false if !(casted_status === result.status)
                      return false if !data.nil? && !(casted_data === result.unsafe_data)
                      return false if !message.nil? && !(casted_message === result.unsafe_message)
                      return false if !code.nil? && !(casted_code === result.unsafe_code)

                      true
                    end

                    ##
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def handle
                      block.call(
                        Support::Arguments.new(
                          status: casted_status,
                          data: data.nil? ? nil : casted_data,
                          message: message.nil? ? nil : casted_message,
                          code: code.nil? ? nil : casted_code
                        )
                      )
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

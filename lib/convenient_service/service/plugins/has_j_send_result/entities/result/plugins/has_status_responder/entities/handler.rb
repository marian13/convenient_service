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
                    # @api private
                    #
                    # @!attribute [r] result
                    #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    attr_reader :result

                    ##
                    # @api private
                    #
                    # @!attribute [r] status
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :status

                    ##
                    # @api private
                    #
                    # @!attribute [r] data
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :data

                    ##
                    # @api private
                    #
                    # @!attribute [r] message
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :message

                    ##
                    # @api private
                    #
                    # @!attribute [r] code
                    #   @return [Object] Can be any type.
                    #
                    attr_reader :code

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
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_status
                      @casted_status ||= result.create_status(status)
                    end

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_data
                      @casted_data ||= result.create_data(data)
                    end

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_message
                      @casted_message ||= result.create_message(message)
                    end

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def casted_code
                      @casted_code ||= result.create_code(code)
                    end

                    ##
                    # @api private
                    #
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
                    # @api private
                    #
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def handle
                      kwargs = {status: casted_status}

                      kwargs[:data] = casted_data unless data.nil?
                      kwargs[:message] = casted_message unless message.nil?
                      kwargs[:code] = casted_code unless code.nil?

                      block.call(Support::Arguments.new(**kwargs))
                    end

                    ##
                    # @api private
                    #
                    # @param other [Object] Can be any type.
                    # @return [Boolean, nil]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if result != other.result
                      return false if status != other.status
                      return false if data != other.data
                      return false if message != other.message
                      return false if code != other.code
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

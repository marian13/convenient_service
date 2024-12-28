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
                  class Collector
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
                    # @!attribute [r] block
                    #   @return [Proc]
                    #
                    attr_reader :block

                    ##
                    # @api private
                    #
                    # @!attribute [r] handlers
                    #   @return [Array<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler>]
                    #
                    attr_reader :handlers

                    ##
                    # @api private
                    #
                    # @!attribute [r] unexpected_handler
                    #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::UnexpectedHandler, nil]
                    #
                    # @internal
                    #   NOTE: `@unexpected_handler` is set by `#initialize` and `#unexpected`.
                    #
                    attr_reader :unexpected_handler

                    ##
                    # @api private
                    #
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @param block [Proc]
                    # @param handlers [Array<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler>]
                    # @param unexpected_handler [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::UnexpectedHandler]
                    # @return [void]
                    #
                    def initialize(result:, block:, handlers: [], unexpected_handler: nil)
                      @result = result
                      @block = block
                      @handlers = handlers
                      @unexpected_handler = unexpected_handler
                    end

                    ##
                    # @api public
                    #
                    # @param data [Object] Can be any type.
                    # @param message [Object] Can be any type.
                    # @param code [Object] Can be any type.
                    # @param block [Proc]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector]
                    #
                    def success(data: nil, message: nil, code: nil, &block)
                      handlers << Entities::Handler.new(result: result, status: :success, data: data, message: message, code: code, block: block)

                      self
                    end

                    ##
                    # @api public
                    #
                    # @param data [Object] Can be any type.
                    # @param message [Object] Can be any type.
                    # @param code [Object] Can be any type.
                    # @param block [Proc]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector]
                    #
                    def failure(data: nil, message: nil, code: nil, &block)
                      handlers << Entities::Handler.new(result: result, status: :failure, data: data, message: message, code: code, block: block)

                      self
                    end

                    ##
                    # @api public
                    #
                    # @param data [Object] Can be any type.
                    # @param message [Object] Can be any type.
                    # @param code [Object] Can be any type.
                    # @param block [Proc]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector]
                    #
                    def error(data: nil, message: nil, code: nil, &block)
                      handlers << Entities::Handler.new(result: result, status: :error, data: data, message: message, code: code, block: block)

                      self
                    end

                    ##
                    # @api public
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Collector]
                    #
                    def unexpected(&block)
                      @unexpected_handler = Entities::UnexpectedHandler.new(block: block)

                      self
                    end

                    ##
                    # @api private
                    #
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def handle
                      block.call(self)

                      result.success?(mark_as_checked: true)

                      return matched_handler.handle if matched_handler
                      return unexpected_handler.handle if unexpected_handler

                      nil
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
                      return false if block != other.block
                      return false if handlers != other.handlers
                      return false if unexpected_handler != other.unexpected_handler

                      true
                    end

                    private

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasStatusResponder::Entities::Handler, nil]
                    #
                    def matched_handler
                      Utils.memoize_including_falsy_values(self, :@matched_handler) { handlers.find(&:matches?) }
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

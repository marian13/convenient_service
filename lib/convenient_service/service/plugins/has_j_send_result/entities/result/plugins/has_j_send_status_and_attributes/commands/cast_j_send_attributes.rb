# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Commands
                  class CastJSendAttributes < Support::Command
                    ##
                    # @!attribute [r] result
                    #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    attr_reader :result

                    ##
                    # @!attribute [r] kwargs
                    #   @return [Hash{Symbol => Object}]
                    #
                    attr_reader :kwargs

                    ##
                    # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @param kwargs [Hash{Symbol => Object}]
                    # @return [void]
                    #
                    def initialize(result:, kwargs:)
                      @result = result
                      @kwargs = kwargs
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Structs::JSendAttributes]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def call
                      Structs::JSendAttributes.new(service: service, status: status, data: data, message: message, code: code, extra_kwargs: extra_kwargs)
                    end

                    private

                    ##
                    # @return [Object]
                    #
                    def service
                      kwargs[:service]
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def status
                      @status ||= result.class.status(value: kwargs[:status], result: result)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def data
                      @data ||= result.class.data(value: kwargs[:data], result: result)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def message
                      @message ||= result.class.message(value: kwargs[:message], result: result)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def code
                      @code ||= result.class.code(value: kwargs[:code], result: result)
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def extra_kwargs
                      @extra_kwargs ||= Utils::Hash.except(kwargs, [:service, :status, :data, :message, :code])
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

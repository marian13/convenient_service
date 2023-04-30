# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Commands
                  class CastJSendAttributes < Support::Command
                    ##
                    # @!attribute [r] result
                    #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    attr_reader :result

                    ##
                    # @!attribute [r] kwargs
                    #   @return [Hash{Symbol => Object}]
                    #
                    attr_reader :kwargs

                    ##
                    # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    # @param kwargs [Hash{Symbol => Object}]
                    # @return [void]
                    #
                    def initialize(result:, kwargs:)
                      @result = result
                      @kwargs = kwargs
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Structs::JSendAttributes]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    def call
                      Structs::JSendAttributes.new(service: service, status: status, data: data, message: message, code: code)
                    end

                    ##
                    # @return [Object]
                    #
                    def service
                      kwargs[:service]
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    def status
                      @status ||= result.class.status_class.cast!(kwargs[:status])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    def data
                      @data ||= result.class.data_class.cast!(kwargs[:data])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    def message
                      @message ||= result.class.message_class.cast!(kwargs[:message])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Errors::FailedToCast]
                    #
                    def code
                      @code ||= result.class.code_class.cast!(kwargs[:code])
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

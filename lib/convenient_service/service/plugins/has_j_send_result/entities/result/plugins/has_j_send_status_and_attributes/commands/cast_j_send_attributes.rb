# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
                      @status ||= result.create_status!(kwargs[:status])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def data
                      @data ||= result.create_data!(kwargs[:data])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def message
                      @message ||= result.create_message!(kwargs[:message])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def code
                      @code ||= result.create_code!(kwargs[:code])
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

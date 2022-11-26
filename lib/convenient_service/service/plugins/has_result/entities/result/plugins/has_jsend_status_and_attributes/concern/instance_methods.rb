# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Concern
                  ##
                  # TODO: How to use concern outside?
                  #
                  module InstanceMethods
                    include Support::Delegate
                    include Support::Copyable

                    ##
                    # @return [Boolean]
                    #
                    delegate :success?, to: :status

                    ##
                    # @return [Boolean]
                    #
                    delegate :failure?, to: :status

                    ##
                    # @return [Boolean]
                    #
                    delegate :error?, to: :status

                    ##
                    # @return [Boolean]
                    #
                    delegate :not_success?, to: :status

                    ##
                    # @return [Boolean]
                    #
                    delegate :not_failure?, to: :status

                    ##
                    # @return [Boolean]
                    #
                    delegate :not_error?, to: :status

                    ##
                    # @return [Class]
                    #
                    def service
                      internals.cache[:jsend_attributes].service
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Status]
                    #
                    def status
                      internals.cache[:jsend_attributes].status
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data]
                    #
                    def data
                      internals.cache[:jsend_attributes].data
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message]
                    #
                    def message
                      internals.cache[:jsend_attributes].message
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code]
                    #
                    def code
                      internals.cache[:jsend_attributes].code
                    end

                    ##
                    # @param other [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    # @return [Boolean, nil]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if service.class != other.service.class
                      return false if status != other.status
                      return false if data != other.data
                      return false if message != other.message
                      return false if code != other.code

                      true
                    end

                    ##
                    # @return [Hash]
                    #
                    def to_kwargs
                      {service: service, status: status, data: data, message: message, code: code}
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

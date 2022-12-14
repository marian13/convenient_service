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
                    delegate :service, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Status]
                    #
                    delegate :status, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data]
                    #
                    delegate :data, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Data]
                    #
                    alias_method :unsafe_data, :data

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message]
                    #
                    delegate :message, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Message]
                    #
                    alias_method :unsafe_message, :message

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code]
                    #
                    delegate :code, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Entities::Code]
                    #
                    alias_method :unsafe_code, :code

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJsendStatusAndAttributes::Structs::JSendAttributes]
                    #
                    def jsend_attributes
                      internals.cache[:jsend_attributes]
                    end

                    ##
                    # @param other [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    # @return [Boolean, nil]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if service.class != other.service.class
                      return false if status != other.status
                      return false if unsafe_data != other.unsafe_data
                      return false if unsafe_message != other.unsafe_message
                      return false if unsafe_code != other.unsafe_code

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

# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
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
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    #
                    delegate :status, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    #
                    delegate :data, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    #
                    alias_method :unsafe_data, :data

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    #
                    delegate :message, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    #
                    alias_method :unsafe_message, :message

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    #
                    delegate :code, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    #
                    alias_method :unsafe_code, :code

                    ##
                    # @return [Hash{Object => Symbol}]
                    #
                    delegate :extra_kwargs, to: :jsend_attributes

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Structs::JSendAttributes]
                    #
                    def jsend_attributes
                      internals.cache[:jsend_attributes]
                    end

                    ##
                    # @param status [Symbol]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_status(status)
                      self.class.status_class.cast(status)&.copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param status [Symbol]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_status!(status)
                      self.class.status_class.cast!(status).copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param data [Hash{Symbol => Object}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_data(data)
                      self.class.data_class.cast(data)&.copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param data [Hash{Symbol => Object}]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Data]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_data!(data)
                      self.class.data_class.cast!(data).copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param message [String]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_message(message)
                      self.class.message_class.cast(message)&.copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param message [String]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Message]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_message!(message)
                      self.class.message_class.cast!(message).copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param code [Symbol]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_code(code)
                      self.class.code_class.cast(code)&.copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param code [Symbol]
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Code]
                    # @raise [ConvenientService::Support::Castable::Exceptions::FailedToCast]
                    #
                    def create_code!(code)
                      self.class.code_class.cast!(code).copy(overrides: {kwargs: {result: self}})
                    end

                    ##
                    # @param other [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    # @return [Boolean, nil]
                    #
                    # @internal
                    #   TODO: Currently `==` does NOT compare `extra_kwargs`. Is it OK?
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
                    # @return [Hash{Symbol => Object}]
                    #
                    def to_kwargs
                      to_arguments.kwargs
                    end

                    ##
                    # @return [ConveninentService::Support::Arguments]
                    #
                    def to_arguments
                      Support::Arguments.new(
                        service: service,
                        status: status,
                        data: unsafe_data,
                        message: unsafe_message,
                        code: unsafe_code,
                        **extra_kwargs
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

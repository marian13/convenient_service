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
                    # @return [Symbol]
                    #
                    def create_status(status)
                      self.class.status(value: status, result: self)
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def create_data(data)
                      self.class.data(value: data, result: self)
                    end

                    ##
                    # @return [String]
                    #
                    def create_message(message)
                      self.class.message(value: message, result: self)
                    end

                    ##
                    # @return [Symbol]
                    #
                    def create_code(code)
                      self.class.code(value: code, result: self)
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

                    ##
                    # Returns a boolean representation of `result`.
                    # `success` may be considered as `true`.
                    # `failure` may be considered as `false`.
                    # `error` may be considered as `raise exception`.
                    #
                    # @api public
                    # @return [Boolean]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Exceptions::ErrorHasNoOtherTypeRepresentation]
                    #
                    # @note This method is useful for learning purposes, to show similarities with Ruby's booleans. Please, do NOT depend on it in production.
                    #
                    # @internal
                    #   NOTE: When `value` is NOT `:success`, `:failure` or `:error`, then something fatal has happened.
                    #
                    def to_bool
                      case status.value
                      when :success
                        true
                      when :failure
                        false
                      when :error
                        raise ::ConvenientService.raise Exceptions::ErrorHasNoOtherTypeRepresentation.new(type: :boolean)
                      else
                        raise ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Unknown result status `#{status.value}`.")
                      end
                    end

                    ##
                    # Returns a boolean representation of `result`.
                    # `success` may be considered as `object`.
                    # `failure` may be considered as `nil` (or null object).
                    # `error` may be considered as `raise exception`.
                    #
                    # @api public
                    # @return [ConvenientService::Support::Value]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Exceptions::ErrorHasNoOtherTypeRepresentation]
                    #
                    # @note This method is useful for learning purposes, to show similarities with Ruby's objects. Please, do NOT depend on it in production.
                    #
                    # @internal
                    #   NOTE: When `value` is NOT `:success`, `:failure` or `:error`, then something fatal has happened.
                    #
                    def to_object
                      case status.value
                      when :success
                        Support::Value.new("object")
                      when :failure
                        nil
                      when :error
                        raise ::ConvenientService.raise Exceptions::ErrorHasNoOtherTypeRepresentation.new(type: :object)
                      else
                        raise ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Unknown result status `#{status.value}`.")
                      end
                    end

                    ##
                    # Returns an array representation of `result`.
                    # `success` may be considered as array with items.
                    # `failure` may be considered as empty array.
                    # `error` may be considered as `raise exception`.
                    #
                    # @api public
                    # @return [Array<ConvenientService::Support::Value>]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Exceptions::ErrorHasNoOtherTypeRepresentation]
                    #
                    # @note This method is useful for learning purposes, to show similarities with Ruby's objects. Please, do NOT depend on it in production.
                    #
                    # @internal
                    #   NOTE: When `value` is NOT `:success`, `:failure` or `:error`, then something fatal has happened.
                    #
                    def to_a
                      case status.value
                      when :success
                        [Support::Value.new("item")]
                      when :failure
                        []
                      when :error
                        raise ::ConvenientService.raise Exceptions::ErrorHasNoOtherTypeRepresentation.new(type: :array)
                      else
                        raise ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Unknown result status `#{status.value}`.")
                      end
                    end

                    ##
                    # Returns a hash representation of `result`.
                    # `success` may be considered as hash with items.
                    # `failure` may be considered as empty hash.
                    # `error` may be considered as `raise exception`.
                    #
                    # @api public
                    # @return [Hash{ConvenientService::Support::Value => ConvenientService::Support::Value}]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Exceptions::ErrorHasNoOtherTypeRepresentation]
                    #
                    # @note This method is useful for learning purposes, to show similarities with Ruby's objects. Please, do NOT depend on it in production.
                    #
                    # @internal
                    #   NOTE: When `value` is NOT `:success`, `:failure` or `:error`, then something fatal has happened.
                    #
                    def to_h
                      case status.value
                      when :success
                        {Support::Value.new("key") => Support::Value.new("value")}
                      when :failure
                        {}
                      when :error
                        raise ::ConvenientService.raise Exceptions::ErrorHasNoOtherTypeRepresentation.new(type: :hash)
                      else
                        raise ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Unknown result status `#{status.value}`.")
                      end
                    end

                    ##
                    # Returns a string representation of `result`.
                    # `success` may be considered as string with content.
                    # `failure` may be considered as empty string.
                    # `error` may be considered as `raise exception`.
                    #
                    # @api public
                    # @return [String]
                    # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status::Exceptions::ErrorHasNoOtherTypeRepresentation]
                    #
                    # @note This method is useful for learning purposes, to show similarities with Ruby's objects. Please, do NOT depend on it in production.
                    #
                    # @internal
                    #   NOTE: When `value` is NOT `:success`, `:failure` or `:error`, then something fatal has happened.
                    #
                    def to_s
                      case status.value
                      when :success
                        "string"
                      when :failure
                        ""
                      when :error
                        raise ::ConvenientService.raise Exceptions::ErrorHasNoOtherTypeRepresentation.new(type: :string)
                      else
                        raise ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Unknown result status `#{status.value}`.")
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

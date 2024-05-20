# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HelpsToLearnSimilaritiesWithCommonObjects
                module Concern
                  module InstanceMethods
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

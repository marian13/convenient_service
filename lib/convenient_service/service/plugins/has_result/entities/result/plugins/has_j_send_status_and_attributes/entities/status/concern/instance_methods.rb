# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Status
                    module Concern
                      module InstanceMethods
                        ##
                        # @!attribute [r] value
                        #   @return [String]
                        #
                        attr_reader :value

                        ##
                        # @param value [String]
                        # @return [void]
                        #
                        def initialize(value:)
                          @value = value
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          casted = cast(other)

                          return unless casted

                          value == casted.value
                        end

                        ##
                        # @return [Boolean]
                        #
                        def success?
                          value == :success
                        end

                        # def ok?
                        #   value == :success
                        # end

                        ##
                        # @return [Boolean]
                        #
                        def failure?
                          value == :failure
                        end

                        ##
                        # @return [Boolean]
                        #
                        def error?
                          value == :error
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_success?
                          !success?
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_failure?
                          !failure?
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_error?
                          !error?
                        end

                        ##
                        # @param statuses [Array<Symbol, String, ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status>]
                        # @return [Boolean]
                        #
                        def in?(statuses)
                          statuses.any? { |status| self == status }
                        end

                        ##
                        # @return [String]
                        #
                        def to_s
                          @to_s ||= value.to_s
                        end

                        ##
                        # @return [Symbol]
                        #
                        def to_sym
                          @to_sym ||= value.to_sym
                        end

                        alias_method :ok?, :success?
                        alias_method :not_ok?, :not_success?
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

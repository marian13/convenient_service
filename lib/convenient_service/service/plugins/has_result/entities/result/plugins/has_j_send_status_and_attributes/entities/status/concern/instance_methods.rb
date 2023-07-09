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
                        include Support::Copyable

                        ##
                        # @!attribute [r] value
                        #   @return [String]
                        #
                        attr_reader :value

                        ##
                        # @!attribute [r] result
                        #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                        #
                        attr_reader :result

                        ##
                        # @param value [String]
                        # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                        # @return [void]
                        #
                        def initialize(value:, result: nil)
                          @value = value
                          @result = result
                        end

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          return unless other.instance_of?(self.class)

                          return false if result.class != other.result.class
                          return false if value != other.value

                          true
                        end

                        ##
                        # @return [Boolean]
                        #
                        def success?
                          value == :success
                        end

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
                        # @param statuses [Array<ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status>]
                        # @return [Boolean]
                        #
                        def in?(statuses)
                          statuses.any? { |status| self == status }
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
                          @to_arguments ||= Support::Arguments.new(value: value, result: result)
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

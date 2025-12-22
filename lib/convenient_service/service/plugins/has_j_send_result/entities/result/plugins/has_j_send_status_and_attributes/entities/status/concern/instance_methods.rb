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
                        #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        #
                        attr_reader :result

                        ##
                        # @param value [String]
                        # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
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
                        def unsafe_success?
                          value == :success
                        end

                        ##
                        # @return [Boolean]
                        #
                        def unsafe_failure?
                          value == :failure
                        end

                        ##
                        # @return [Boolean]
                        #
                        def unsafe_error?
                          value == :error
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_success?
                          value != :success
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_failure?
                          value != :failure
                        end

                        ##
                        # @return [Boolean]
                        #
                        def not_error?
                          value != :error
                        end

                        ##
                        # @return [Boolean]
                        #
                        def unsafe_not_success?
                          value != :success
                        end

                        ##
                        # @return [Boolean]
                        #
                        def unsafe_not_failure?
                          value != :failure
                        end

                        ##
                        # @return [Boolean]
                        #
                        def unsafe_not_error?
                          value != :error
                        end

                        ##
                        # @param statuses [Array<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Entities::Status>]
                        # @return [Boolean]
                        #
                        # @internal
                        #   NOTE: `any?(arg)` compares with `===`. For this method `==` is mandatory.
                        #
                        # rubocop:disable Performance/RedundantEqualityComparisonBlock
                        def in?(statuses)
                          statuses.any? { |status| self == status }
                        end
                        # rubocop:enable Performance/RedundantEqualityComparisonBlock

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

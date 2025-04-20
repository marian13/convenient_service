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
                  class Code
                    module Concern
                      module InstanceMethods
                        include Support::Copyable

                        ##
                        # @!attribute [r] value
                        #   @return [Symbol]
                        #
                        attr_reader :value

                        ##
                        # @!attribute [r] result
                        #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        #
                        attr_reader :result

                        ##
                        # @param value [Symbol]
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
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        # @note `Code#===` allows to use RSpec expectation matchers and RSpec mocks arguments matchers for comparison.
                        #
                        # @example RSpec expectation matchers.
                        #   expect(result).to be_error.with_code(match(/bar/))
                        #
                        # @see https://rspec.info/features/3-12/rspec-expectations/built-in-matchers
                        # @see https://rspec.info/documentation/3.12/rspec-expectations/RSpec/Matchers/BuiltIn.html
                        # @see https://github.com/rspec/rspec-expectations/blob/v3.12.3/lib/rspec/matchers/composable.rb#L45
                        #
                        # @example RSpec mocks arguments matchers.
                        #   expect(result).to be_success.with_code(instance_of(Symbol))
                        #
                        # @see https://rspec.info/features/3-12/rspec-mocks/setting-constraints/matching-arguments
                        # @see https://rspec.info/documentation/3.12/rspec-mocks/RSpec/Mocks/ArgumentMatchers.html
                        # @see https://github.com/rspec/rspec-mocks/blob/v3.12.3/lib/rspec/mocks/argument_matchers.rb#L282
                        #
                        # @example Just code does NOT work in case/when.
                        #
                        #   case result.code # `result.code` returns fancy object
                        #   when :full_queue
                        #     notify_devops
                        #   when :duplicated_job
                        #     notify_devs
                        #   else
                        #     # ...
                        #   end
                        #
                        # @example Code converted to symbol works in case/when.
                        #
                        #   case result.code.to_sym
                        #   when :full_queue
                        #     notify_devops
                        #   when :duplicated_job
                        #     notify_devs
                        #   else
                        #     # ...
                        #   end
                        #
                        # @see https://userdocs.convenientservice.org/faq#why-casewhen-does-not-work-with-just-result-codes
                        #
                        # @internal
                        #   IMPORTANT: Must be kept in sync with `#==`.
                        #   NOTE: Ruby does NOT have `!==` operator.
                        #
                        def ===(other)
                          return unless other.instance_of?(self.class)

                          return false if result.class != other.result.class
                          return false unless value === other.value

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

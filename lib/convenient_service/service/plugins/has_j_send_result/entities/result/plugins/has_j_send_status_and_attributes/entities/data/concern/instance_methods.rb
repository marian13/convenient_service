# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
                    module Concern
                      module InstanceMethods
                        include Support::Copyable

                        ##
                        # @!attribute [r] value
                        #   @return [Hash]
                        #
                        attr_reader :value

                        ##
                        # @!attribute [r] result
                        #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        #
                        attr_reader :result

                        ##
                        # @param value [Hash]
                        # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        # @return [void]
                        #
                        # @internal
                        #   NOTE: Ruby hashes enumerate their values in the order that the corresponding keys were inserted.
                        #   That is why the end-user can be 100% sure that the failure message is always generated from the first key/value pair.
                        #   - https://ruby-doc.org/core-2.7.0/Hash.html
                        #
                        #   TODO: A test that crashes when such behaviour is broken.
                        #
                        #   NOTE: As a result, there is NO need to use any custom `OrderedHash` implementations.
                        #   - https://api.rubyonrails.org/v5.1/classes/ActiveSupport/OrderedHash.html
                        #   - https://github.com/rails/rails/issues/22681
                        #   - https://api.rubyonrails.org/classes/ActiveSupport/OrderedOptions.html
                        #
                        def initialize(value:, result: nil)
                          @value = value
                          @result = result
                        end

                        ##
                        # @param key [String, Symbol]
                        # @return [Boolean]
                        #
                        def has_attribute?(key)
                          value.has_key?(key.to_sym)
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
                        # @note `Data#===` allows to use RSpec expectation matchers and RSpec mocks arguments matchers for comparison.
                        #
                        # @example RSpec expectation matchers.
                        #   expect(result).to be_success.with_data(foo: match(/bar/))
                        #
                        # @see https://rspec.info/features/3-12/rspec-expectations/built-in-matchers
                        # @see https://rspec.info/documentation/3.12/rspec-expectations/RSpec/Matchers/BuiltIn.html
                        # @see https://github.com/rspec/rspec-expectations/blob/v3.12.3/lib/rspec/matchers/composable.rb#L45
                        #
                        # @example RSpec mocks arguments matchers.
                        #   expect(result).to be_success.with_data(hash_including(:foo))
                        #
                        # @see https://rspec.info/features/3-12/rspec-mocks/setting-constraints/matching-arguments
                        # @see https://rspec.info/documentation/3.12/rspec-mocks/RSpec/Mocks/ArgumentMatchers.html
                        # @see https://github.com/rspec/rspec-mocks/blob/v3.12.3/lib/rspec/mocks/argument_matchers.rb#L282
                        #
                        # @example Combo of RSpec expectation matchers and RSpec mocks arguments.
                        #   expect(result).to be_success.with_data(hash_including(foo: match(/bar/)))
                        #
                        # @internal
                        #   IMPORTANT: Must be kept in sync with `#==`.
                        #   NOTE: Ruby does NOT have `!==` operator.
                        #
                        #   NOTE:
                        #   - `Hash` and `Array` do NOT implement `#===`.
                        #   - They inherit it from `Object`.
                        #   - `Object#===` is "alias" for `Object#==`.
                        #   - That is why the following method is using a custom comparison logic.
                        #   - https://ruby-doc.org/core-2.7.0/Object.html#method-i-3D-3D-3D
                        #   - https://ruby-doc.org/core-2.7.0/Hash.html#method-i-3D-3D
                        #   - https://ruby-doc.org/core-2.7.0/Array.html#method-i-3D-3D
                        #
                        #   IMPORTANT: @marian13 `Data#===` MUST NOT care about nested arrays and hashes inside `Data#value` hash.
                        #
                        def ===(other)
                          return unless other.instance_of?(self.class)

                          return false if result.class != other.result.class

                          case [value, other.value]
                          in [::Hash, ::Hash]
                            return false unless Utils::Hash.triple_equality_compare(value, other.value)
                          else
                            return false unless value === other.value
                          end

                          true
                        end

                        ##
                        # @param key [String, Symbol]
                        # @return [Object] Can be any type.
                        # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Errors::NotExistingAttribute]
                        #
                        def [](key)
                          value.fetch(key.to_sym) { raise Errors::NotExistingAttribute.new(attribute: key) }
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
                        # @return [Hash]
                        #
                        def to_h
                          @to_h ||= value.to_h
                        end

                        ##
                        # @return [String]
                        #
                        def to_s
                          @to_s ||= to_h.to_s
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

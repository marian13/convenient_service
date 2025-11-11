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
                  class Data
                    module Concern
                      module InstanceMethods
                        include Support::Copyable

                        ##
                        # @!attribute [r] value
                        #   @return [Hash{Symbol => Object}]
                        #
                        # @internal
                        #   NOTE: This method can be overridden by the end-user when the `HasMethodReaders` plugin is utilized. Prefer to rely on `__value__` inside the library code.
                        #
                        attr_reader :value

                        ##
                        # @return [Hash{Symbol => Object}]
                        #
                        alias_method :__value__, :value

                        ##
                        # @!attribute [r] result
                        #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        #
                        # @internal
                        #   NOTE: This method can be overridden by the end-user when the `HasMethodReaders` plugin is utilized. Prefer to rely on `__result__` inside the library code.
                        #
                        attr_reader :result

                        ##
                        # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                        #
                        alias_method :__result__, :result

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
                        # @return [Boolean]
                        #
                        # @internal
                        #   NOTE: This method can be overridden by the end-user when the `HasMethodReaders` plugin is utilized. Prefer to rely on `__empty__?` inside the library code.
                        #
                        def empty?
                          __value__.empty?
                        end

                        ##
                        # @return [Boolean]
                        #
                        alias_method :__empty__?, :empty?

                        ##
                        # @param key [String, Symbol]
                        # @return [Boolean]
                        #
                        # @internal
                        #   NOTE: This method can be overridden by the end-user when the `HasMethodReaders` plugin is utilized. Prefer to rely on `__has_attribute__?` inside the library code.
                        #
                        def has_attribute?(key)
                          __value__.has_key?(key.to_sym)
                        end

                        ##
                        # @return [Boolean]
                        #
                        alias_method :__has_attribute__?, :has_attribute?

                        ##
                        # @return [Hash{Symbol => Object}]
                        #
                        def attributes
                          __value__
                        end

                        ##
                        # @return [Hash{Symbol => Object}]
                        #
                        alias_method :__attributes__, :attributes

                        ##
                        # @return [Array<Symbol>]
                        #
                        # @internal
                        #   NOTE: This method can be overridden by the end-user when the `HasMethodReaders` plugin is utilized. Prefer to rely on `__keys__` inside the library code.
                        #
                        def keys
                          __value__.keys
                        end

                        ##
                        # @return [Array<Symbol>]
                        #
                        alias_method :__keys__, :keys

                        ##
                        # @return [Struct]
                        #
                        def struct
                          @struct ||= ::Struct.new(*__value__.keys, keyword_init: true).new(__value__)
                        end

                        ##
                        # @return [Array<Symbol>]
                        #
                        alias_method :__struct__, :struct

                        ##
                        # @param other [Object] Can be any type.
                        # @return [Boolean, nil]
                        #
                        def ==(other)
                          return unless other.instance_of?(self.class)

                          return false if __result__.class != other.__result__.class
                          return false if __value__ != other.__value__

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

                          return false if __result__.class != other.__result__.class

                          ##
                          # NOTE: Pattern matching is removed since it causes a huge and annoying warning in Ruby 2.7 apps. Users are too confused by it.
                          #
                          # TODO: Implement a Rubocop cop that forbids the usage of pattern matching until Ruby 2.7 is dropped.
                          #
                          if __value__.instance_of?(::Hash) && other.__value__.instance_of?(::Hash)
                            return false unless Utils::Hash.triple_equality_compare(__value__, other.__value__)
                          else
                            return false unless __value__ === other.__value__
                          end

                          true
                        end

                        ##
                        # @param key [String, Symbol]
                        # @return [Object] Can be any type.
                        # @raise [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Plugins::HasJSendStatusAndAttributes::Exceptions::NotExistingAttribute]
                        #
                        def [](key)
                          __value__.fetch(key.to_sym) { ::ConvenientService.raise Exceptions::NotExistingAttribute.new(attribute: key) }
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
                          @to_arguments ||= Support::Arguments.new(value: __value__, result: __result__)
                        end

                        ##
                        # @return [Hash{Symbol => Object}]
                        #
                        def to_h
                          @to_h ||= __value__.to_h
                        end

                        ##
                        # @return [String]
                        #
                        def to_s
                          @to_s ||= __value__.to_h.to_s
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

# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      ##
      # @example
      #   Preconditions (pseudo-real world):
      #
      #   - Both `match?` and `match` do exactly the same thing, only their return values are different.
      #   - `match?` returns `true` when the string matches the regex, otherwise - `false`.
      #   - `match` returns regex match data when the string matches the regex, otherwise - `nil`.
      #   - Regex matching is a very resource-heavy process.
      #
      #   - `test` is defined like this:
      #     def test
      #       string = strings.find { |string| string.match?(regexp) }
      #
      #       return unless string
      #
      #       string.match(regexp)
      #     end
      #
      #   - To simplify the example, imagine that `strings` return an array with only one string and that string matches regex.
      #     def strings
      #       ["foo bar"]
      #     end
      #
      #     def regexp
      #       /\w+/
      #     end
      #   - This way regex matching (a very resource-heavy process) is executed twice.
      #   - First time during the `match?` method call.
      #   - The second time during the `match` method call.
      #
      #   Task:
      #   - How to implement `test` in a way that regexp matching (very resource-heavy process) is executed only once for the preconditions above?
      #
      #   Solution:
      #   - Use `ConvenientService::Utils::Array.find_yield`
      #   - `test` should be rewritten like this:
      #     def test
      #       ConvenientService::Utils::Array.find_yield(strings) { |string| string.match(regexp) }
      #     end
      #
      #   Inspiration:
      #   - https://github.com/rubyworks/facets/blob/3.1.0/lib/core/facets/enumerable/find_yield.rb#L28
      #   - https://stackoverflow.com/a/38457218/12201472
      #
      #   Note: `String#match?` and `String#match` docs.
      #   - https://ruby-doc.org/core-2.7.0/String.html#method-i-match-3F
      #   - https://ruby-doc.org/core-2.7.0/String.html#method-i-match
      #
      class FindYield < Support::Command
        ##
        # @!attribute [r] array
        #   @return [Array]
        #
        attr_reader :array

        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param array [Array]
        # @param block [Proc]
        # @return [void]
        #
        def initialize(array, &block)
          @array = array
          @block = block
        end

        ##
        # @return [Object, nil] Can be any type.
        # @see https://github.com/rubyworks/facets/blob/main/lib/core/facets/enumerable/find_yield.rb#L28
        #
        def call
          array.each do |item|
            block_value = block.call(item)

            return block_value if block_value
          end

          nil
        end
      end
    end
  end
end

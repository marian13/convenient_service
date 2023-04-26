# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      ##
      # @internal
      #   IMPORTANT: Since `contain_exactly` uses hashes under the hood, `first_array` and `second_array` items should be comparable by `hash` and `eql?`.
      #   It may sometimes introduce hash collisions, which in turn can degrade the performance.
      #   But since the probability is relatively low, because it is NOT too common to have hashes that contain keys with different classes,
      #   hashes comparison is still preferred over array comparison.
      #   Check specs for more details.
      #   - https://github.com/ruby/spec/blob/master/core/hash/shared/eql.rb
      #   - https://stackoverflow.com/questions/54961311/ruby-why-does-hash-need-to-overridden-whenever-eql-is-overridden
      #   - https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
      #
      #   NOTE: Inspired by `contain_exactly` from `RSpec`.
      #   - https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/contain-exactly-matcher
      #
      class ContainExactly < Support::Command
        ##
        # @!attribute [r] first_array
        #   @return [Array]
        #
        attr_reader :first_array

        ##
        # @!attribute [r] second_array
        #   @return [Array]
        #
        attr_reader :second_array

        ##
        # @param first_array [Array]
        # @param second_array [Array]
        # @return [Boolean]
        #
        def initialize(first_array, second_array)
          @first_array = first_array
          @second_array = second_array
        end

        ##
        # @return [Boolean]
        #
        def call
          first_array.tally == second_array.tally
        end
      end
    end
  end
end

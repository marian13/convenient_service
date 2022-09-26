# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      ##
      # IMPORTANT: Since `contain_exactly` uses hashes under the hood, `first_array` and `second_array` items should be comparable by `hash` and `eql?`.
      # It may sometimes introduce hash collisions, which in turn can degrade the performance.
      # But since the probability is relatively low, because it is NOT too common to have hashes that contain keys with different classes,
      # hashes comparison is still preferred over array comparison.
      # Check specs for more details.
      # https://github.com/ruby/spec/blob/master/core/hash/shared/eql.rb
      # https://stackoverflow.com/questions/54961311/ruby-why-does-hash-need-to-overridden-whenever-eql-is-overridden
      # https://ruby-doc.org/core-3.1.2/Object.html#method-i-hash
      #
      # NOTE: Inspired by `contain_exactly` from `RSpec`.
      # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/contain-exactly-matcher
      #
      class ContainExactly < Support::Command
        attr_reader :first_array, :second_array

        def initialize(first_array, second_array)
          @first_array = first_array
          @second_array = second_array
        end

        def call
          first_array_counts = first_array.each_with_object(::Hash.new { |h, k| h[k] = 0 }) { |item, counts| counts[item] += 1 }

          second_array_counts = second_array.each_with_object(::Hash.new { |h, k| h[k] = 0 }) { |item, counts| counts[item] += 1 }

          first_array_counts == second_array_counts
        end
      end
    end
  end
end

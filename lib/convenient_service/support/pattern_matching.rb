# frozen_string_literal: true

require_relative "pattern_matching/entities"

module ConvenientService
  module Support
    ##
    # NOTE: Custom pattern matching.
    # Pattern matching is "a mechanism for checking a value against a pattern".
    # "A successful match can also deconstruct a value into its constituent parts."
    # https://www.toptal.com/ruby/ruby-pattern-matching-tutorial
    #
    module PatternMatching
      class << self
        ##
        # TODO: Specs.
        #
        def compile_pattern(hash)
          Entities::Pattern.new(hash)
        end

        ##
        # TODO: Specs for `inspect`.
        #
        def anything
          @anything ||=
            ::Object.new
              .tap { |object| object.define_singleton_method(:==) { |other| true } }
              .tap { |object| object.define_singleton_method(:inspect) { "anything" } }
        end

        ##
        # TODO: Specs for `inspect`. Specs for optional argument.
        #
        def unique_value(inspect_value = "unique_value")
          ::Object.new
            .tap { |object| object.define_singleton_method(:inspect) { inspect_value } }
        end
      end
    end
  end
end

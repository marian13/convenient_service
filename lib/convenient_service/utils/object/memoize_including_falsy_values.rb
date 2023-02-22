# frozen_string_literal: true

##
#
#
module ConvenientService
  module Utils
    module Object
      ##
      # Can be used instead of `return @ivar if defined? @ivar`.
      # @see https://www.justinweiss.com/articles/4-simple-memoization-patterns-in-ruby-and-one-gem/
      #
      # @note: `false` and `nil` are the only values that are considered `falsy` in Ruby.
      # @see https://riptutorial.com/ruby/example/2092/truthy-and-falsy-values
      # @see https://www.ruby-lang.org/en/documentation/faq/6/
      #
      # @internal
      #   NOTE: `falsy` is probably more common than `falsey`.
      #   - https://developer.mozilla.org/en-US/docs/Glossary/Falsy
      #
      class MemoizeIncludingFalsyValues < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object]
        #
        attr_reader :object

        ##
        # @!attribute [r] ivar_name
        #   @return [Symbol, String]
        #
        attr_reader :ivar_name

        ##
        # @!attribute [r] value_block
        #   @return [Proc, nil]
        #
        attr_reader :value_block

        ##
        # @param object [Object]
        # @param ivar_name [Symbol]
        # @param value_block [Proc]
        # @return [void]
        #
        def initialize(object, ivar_name, &value_block)
          @object = object
          @ivar_name = ivar_name
          @value_block = value_block
        end

        ##
        # @return [Object] Value of ivar. Can be any type.
        #
        def call
          Utils::Object.instance_variable_fetch(object, ivar_name, &value_block)
        end
      end
    end
  end
end

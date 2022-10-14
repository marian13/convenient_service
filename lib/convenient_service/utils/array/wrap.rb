# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      class Wrap < Support::Command
        ##
        # @!attribute [r] pad
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @param object [Object] Can be any type.
        # @return [void]
        #
        def initialize(object)
          @object = object
        end

        ##
        # @return [Array]
        #
        # @internal
        #   Copied without any modifications from:
        #   https://api.rubyonrails.org/classes/Array.html#method-c-wrap
        #
        def call
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end
      end
    end
  end
end

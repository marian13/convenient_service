# frozen_string_literal: true

module ConvenientService
  module Utils
    module String
      class Split < Support::Command
        ##
        # @!attribute [r] string
        #   @return [#to_s]
        #
        attr_reader :string

        ##
        # @!attribute [r] delimiters
        #   @return [Array<String>]
        #
        attr_reader :delimiters

        ##
        # @param string [Symbol, String]
        # @param delimiters [Array<String>]
        # @return [void]
        #
        def initialize(string, *delimiters)
          @string = string
          @delimiters = delimiters
        end

        ##
        # @return [String]
        #
        # @internal
        #   https://stackoverflow.com/a/51380514/12201472
        #
        def call
          string.to_s.split(::Regexp.union(delimiters))
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Utils
    module String
      class Enclose < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] char
        #   @return [String]
        #
        attr_reader :char

        ##
        # @param string [#to_s]
        # @param char [String]
        # @return [void]
        #
        def initialize(string, char)
          @string = string
          @char = char
        end

        ##
        # @return [String]
        #
        def call
          return char unless string

          "#{char}#{string}#{char}"
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Utils
    module String
      ##
      # @example
      #   ConvenientService::Utils::String.truncate("hello", -1)                 # => ""
      #   ConvenientService::Utils::String.truncate("hello", 0)                  # => ""
      #   ConvenientService::Utils::String.truncate("hello", 1)                  # => "."
      #   ConvenientService::Utils::String.truncate("hello", 2)                  # => ".."
      #   ConvenientService::Utils::String.truncate("hello", 3)                  # => "..."
      #   ConvenientService::Utils::String.truncate("hello", 4)                  # => "h..."
      #   ConvenientService::Utils::String.truncate("hello", 4, omission: "--")  # => "he--"
      #   ConvenientService::Utils::String.truncate("hello", 5)                  # => "hello"
      #   ConvenientService::Utils::String.truncate("hello", 6)                  # => "hello"
      #   ConvenientService::Utils::String.truncate("hello", 7)                  # => "hello"
      #
      # @internal
      #   NOTE: Naming is inspired by `String#truncate` from Rails, but behaviour is different.
      #   - https://api.rubyonrails.org/classes/String.html#method-i-truncate
      #
      class Truncate < Support::Command
        ##
        # @!attribute [r] string
        #   @return [String]
        #
        attr_reader :string

        ##
        # @!attribute [r] truncate_at
        #   @return [Integer]
        #
        attr_reader :truncate_at

        ##
        # @!attribute [r] omission
        #   @return [Integer]
        #
        attr_reader :omission

        ##
        # @param string [#to_s]
        # @param truncate_at [Integer]
        # @param omission [String]
        # @return [void]
        #
        def initialize(string, truncate_at, omission: "...")
          @string = string.to_s
          @truncate_at = truncate_at
          @omission = omission
        end

        ##
        # @return [String]
        #
        def call
          return "" if truncate_at <= 0

          return string if truncate_at >= string.length

          return omission[...truncate_at] if truncate_at <= omission.length

          "#{string[...truncate_at - omission.length]}#{omission}"
        end
      end
    end
  end
end

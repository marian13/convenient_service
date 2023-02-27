# frozen_string_literal: true

require_relative "cache/array"
require_relative "cache/hash"
require_relative "cache/key"

module ConvenientService
  module Support
    class Cache
      def self.set_default_class(use_array)
        if use_array
          @default_class = Array
        else
          @default_class = Hash
        end
      end

      def self.default_class
        @default_class ||= Hash
      end

      ##
      # @return [Object] Can be any type.
      #
      # @internal
      #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:read).with(key).and_call_original` for both `cache[key]` and `cache.read(key)` in RSpec.
      #
      def [](key)
        read(key)
      end

      ##
      # @param key [Object] Can be any type.
      # @param value [Object] Can be any type.
      # @return [Object] Can be any type.
      #
      # @internal
      #   NOTE: `alias_method` is NOT used in order to have an ability to use `allow(cache).to receive(:write).with(key, value).and_call_original` for both `cache[key] = value` and `cache.write(key, value)` in RSpec.
      #
      def []=(key, value)
        write(key, value)
      end
    end
  end
end

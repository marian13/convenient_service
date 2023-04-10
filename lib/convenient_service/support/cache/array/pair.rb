# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      class Array < Cache
        class Pair
          attr_accessor :key, :value

          def initialize(key:, value:)
            @key = key
            @value = value
          end

          def self.null_pair
            new(key: nil, value: nil)
          end
        end
      end
    end
  end
end

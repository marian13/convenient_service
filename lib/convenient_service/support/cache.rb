# frozen_string_literal: true

require_relative "cache/key"

require_relative "cache/array"
require_relative "cache/hash"

module ConvenientService
  module Support
    class Cache
      module Errors
        class NotSupportedType < ::StandardError
          def initialize(type)
            message = "Invalid cache type: #{type}."

            super(message)
          end
        end
      end

      ##
      # @return [ConvenientService::Support::Cache]
      #
      def self.create(type: :hash)
        case type
        when :array
          Cache::Array.new
        when :hash
          Cache::Hash.new
        else
          raise Errors::NotSupportedType.new(type)
        end
      end
    end
  end
end

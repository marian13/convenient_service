# frozen_string_literal: true

require_relative "factories"

module ConvenientService
  module Factory
    class << self
      ##
      # @param method [String, Symbol]
      # @param kwargs [Hash]
      # @return [Object] Can be any type.
      #
      def create(method, **kwargs)
        Factories.public_send("create_#{method}", **kwargs)
      end
    end
  end
end

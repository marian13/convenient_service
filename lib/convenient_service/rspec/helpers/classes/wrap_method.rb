# frozen_string_literal: true

require_relative "wrap_method/entities"
require_relative "wrap_method/exceptions"

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class WrapMethod < Support::Command
          ##
          # @!attribute [r] entity
          #   @return [Object] Can be any type.
          #
          attr_reader :entity

          ##
          # @!attribute [r] method
          #   @return [Symbol, String]
          #
          attr_reader :method

          ##
          # @!attribute [r] observe_middleware
          #   @return [Class]
          #
          attr_reader :observe_middleware

          ##
          # @param entity [Object] Can be any type.
          # @param method [Symbol, String]
          # @param observe_middleware [Class]
          # @return [void]
          #
          def initialize(entity, method, observe_middleware:)
            @entity = entity
            @method = method
            @observe_middleware = observe_middleware
          end

          ##
          # @return [ConvenientService::RSpec::Helpers::Classes::Entities::WrappedMethod]
          #
          def call
            Entities::WrappedMethod.new(entity: entity, method: method, observe_middleware: observe_middleware)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class DefineEntry < Support::Command
          ##
          # @!attribute [r] container
          #   @return [Module]
          #
          attr_reader :container

          ##
          # @!attribute [r] name
          #   @return [String, Symbol]
          #
          attr_reader :name

          ##
          # @!attribute [r] body
          #   @return [Proc]
          #
          attr_reader :body

          ##
          # @param container [Module]
          # @param name [String, Symbol]
          # @param body [Proc]
          #
          def initialize(container:, name:, body:)
            @container = container
            @name = name
            @body = body
          end

          ##
          # @return [String, Symbol]
          #
          def call
            container.define_singleton_method(name, &body)

            name
          end
        end
      end
    end
  end
end

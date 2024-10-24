# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Commands
          class FindEntityClass < Support::Command
            include Support::Delegate

            ##
            # @!attribute [r] config
            #   @return [Class]
            #
            attr_reader :config

            ##
            # @!attribute [r] name
            #   @return [Symbol]
            #
            attr_reader :name

            ##
            # @return [Class]
            #
            delegate :klass, to: :config

            ##
            # @param config [Class]
            # @param name [Symbol]
            # @return [void]
            #
            def initialize(config:, name:)
              @config = config
              @name = name
            end

            ##
            # @return [Class]
            #
            def call
              klass.const_get(name, false) if klass.const_defined?(name, false)
            end
          end
        end
      end
    end
  end
end

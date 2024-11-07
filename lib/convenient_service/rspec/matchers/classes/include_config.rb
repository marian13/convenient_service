# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class IncludeConfig
          ##
          # @param config [Module]
          #
          def initialize(config)
            @config = config
          end

          ##
          # @param klass [Class]
          # @return [Boolean]
          #
          def matches?(klass)
            @klass = klass

            klass.included_modules.find { |mod| config == mod }
          end

          ##
          # @return [String]
          #
          def description
            "include config `#{config.inspect}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass.inspect}` to include module `#{config.inspect}`"
          end

          ##
          # @return [String]

          def failure_message_when_negated
            "expected `#{klass.inspect}` NOT to include module`#{config.inspect}`"
          end

          private

          ##
          # @!attribute [r] klass
          #   @return [Class]
          #
          attr_reader :klass, :mod

          ##
          # @!attribute [r] config
          #   @return [Module]
          #
          attr_reader :config
        end
      end
    end
  end
end

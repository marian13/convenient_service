# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Import
          ##
          # @param slug [Symbol, String]
          # @param scope [Symbol]
          # @param from [Class, Module]
          # @param prepend [Boolean]
          # @param as [Symbol, String]
          # @return [void]
          #
          def initialize(slug, from:, as: nil, scope: :instance, prepend: false)
            @slug = slug
            @scope = scope
            @from = from
            @prepend = prepend
            @as = as
          end

          ##
          # @param klass [Class, Module]
          # @return [Boolean]
          #
          def matches?(klass)
            # To Do
          end

          ##
          # @return [String]
          #
          def description
            "import `#{slug}` with scope `#{scope}` from `#{from}` prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass}` to have imported `#{slug}` with scope `#{scope}` from `#{from}` prepend: `#{prepend}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass}` NOT to have imported `#{slug}` with scope `#{scope}` from `#{from}` prepend: `#{prepend}`"
          end

          private

          ##
          # @!attribute [r] slug
          #   @return [Symbol, String]
          #
          attr_reader :slug

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] from
          #   @return [Class, Module]
          #
          attr_reader :from

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @!attribute [r] klass
          #   @return [Class, Module]
          #
          attr_reader :klass
        end
      end
    end
  end
end

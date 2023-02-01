# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Import
          ##
          # @param method_name [Symbol, String]
          # @param scope [Symbol]
          # @return [void]
          #
          def initialize(method_name, scope: :instance, from:)
            @method_name = method_name
            @scope = scope
            @from = from
          end

          ##
          # @param container [Class, Module]
          # @return [Boolean]
          #
          def matches?(klass)
            main_namespace = Utils::Module.fetch_own_const(klass, :ImportedIncludedClassMethods)

            return false unless main_namespace

            res = method_name_parts.reduce(main_namespace) do |namespace, name|
              namespace = namespace.namespaces.find_by(name: name) || namespace.methods.select { |el| el == name }.last || namespace.instance_methods.select { |el| el == name }.last
            end

            res == method_name_parts.last
          end

          ##
          # @return [String]
          #
          def description
            "import"
          end

          ##
          # @return [String]
          #
          def failure_message
            "import"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "import"
          end

          private

          def method_name_parts
            @method_name_parts ||= Utils::String.split(method_name, ".", "::").map(&:to_sym)
          end

          attr_reader :method_name
          attr_reader :scope
          attr_reader :from
        end
      end
    end
  end
end

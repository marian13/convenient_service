# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Import
          ##
          # @param method_name [Symbol, String]
          # @param scope [Symbol]
          # @param from [Class, Module]
          # @param prepend [Boolean]
          # @return [void]
          #
          def initialize(method_name, from:, scope: :instance, prepend: false)
            @method_name = method_name
            @scope = scope
            @from = from
            @prepend = prepend
          end

          ##
          # @param klass [Class, Module]
          # @return [Boolean]
          #
          def matches?(klass)
            @klass = klass

            main_namespace = Utils::Module.fetch_own_const(klass, :"Imported#{imported_prefix}#{scoped_prefix}Methods")

            return false unless main_namespace

            actual_method = method_name_parts.reduce(main_namespace) do |namespace, name|
              next namespace unless namespace

              namespace.namespaces.find_by(name: name) || find_method_in(namespace, name)
            end

            actual_method == expected_method
          end

          ##
          # @return [String]
          #
          def description
            "import #{method_name} with scope #{scope} from #{from}"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass.class}` to have imported `#{method_name}` with scope `#{scope}` from `#{from}`, but it's NOT"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass.class}` NOT to have imported `#{method_name}` with scope `#{scope}` from `#{from}`"
          end

          private

          ##
          # @param namespace [Object, Class, Module]
          # @param method [Symbol]
          # @return [Symbol]
          #
          def find_method_in(namespace, method)
            corresponding_methods_for(namespace).find { |method_name| method_name == method }
          end

          ##
          # @param obj [Object, Class, Module]
          # @return [Array]
          #
          def corresponding_methods_for(obj)
            return obj.instance_methods if obj.respond_to? :instance_methods

            obj.singleton_methods
          end

          ##
          # @return [Symbol]
          #
          def expected_method
            @expected_method ||= method_name_parts.last
          end

          ##
          # @return [String]
          #
          def scoped_prefix
            case scope
            when :instance then "Instance"
            when :class then "Class"
            end
          end

          ##
          # @return [String]
          #
          def imported_prefix
            prepend ? "Prepended" : "Included"
          end

          ##
          # @return [Array]
          #
          def method_name_parts
            @method_name_parts ||= Utils::String.split(method_name, ".", "::").map(&:to_sym)
          end

          attr_reader :method_name
          attr_reader :scope
          attr_reader :from
          attr_reader :prepend
          attr_reader :klass
        end
      end
    end
  end
end

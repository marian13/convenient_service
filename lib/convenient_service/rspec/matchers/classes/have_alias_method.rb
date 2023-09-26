# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class HaveAliasMethod
          def initialize(alias_name, original_name)
            @alias_name = alias_name
            @original_name = original_name
          end

          def matches?(object)
            @object = object

            ##
            # TODO: Use `Utils::Object.duck_class` to support `have_alias_method` for classes.
            #
            return false unless Utils::Method.defined?(original_name, object.class, private: true)

            return false unless Utils::Method.defined?(alias_name, object.class, private: true)

            ##
            # https://stackoverflow.com/a/45640516/12201472
            #
            object.method(alias_name).original_name == object.method(original_name).original_name
          end

          def description
            "have alias method `#{alias_name}` for `#{original_name}`"
          end

          def failure_message
            "expected `#{object.class}` to have alias method `#{alias_name}` for `#{original_name}`"
          end

          def failure_message_when_negated
            "expected `#{object.class}` NOT to have alias method `#{alias_name}` for `#{original_name}`"
          end

          private

          attr_reader :object, :alias_name, :original_name
        end
      end
    end
  end
end

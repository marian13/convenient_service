# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
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

            equal_methods?(alias_name, original_name)
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

          ##
          # NOTE: How to compare methods?
          # - https://stackoverflow.com/a/45640516/12201472
          #
          # HACK: CRuby and JRuby have different behaviour when the alias method is defined for the attribute reader. That is why they have their own `equal_methods?` versions. For example:
          #
          #   class Data
          #     attr_reader :result
          #
          #     alias_method :alias_result, :result
          #
          #     def value
          #       @value
          #     end
          #
          #     alias_method :alias_value, :value
          #   end
          #
          #   object = Data.new
          #
          #   # CRuby
          #   object.method(:result).original_name
          #   # => :result
          #
          #   object.method(:alias_result).original_name
          #   # => :result
          #
          #   object.method(:value).original_name
          #   # => :value
          #
          #   object.method(:alias_value).original_name
          #   # => :value
          #
          #   # JRuby
          #   object.method(:result).original_name
          #   # => :result
          #
          #   object.method(:alias_result).original_name
          #   # => :@result
          #
          #   object.method(:value).original_name
          #   # => :value
          #
          #   object.method(:alias_value).original_name
          #   # => :value
          #
          if Dependencies.ruby.match?("jruby < 10.1")
            def equal_methods?(alias_name, original_name)
              alias_method_name = object.method(alias_name).original_name
              original_method_name = object.method(original_name).original_name

              return true if alias_method_name == original_method_name
              return true if alias_method_name.to_s == "@#{original_method_name}"

              false
            end
          else
            def equal_methods?(alias_name, original_name)
              object.method(alias_name).original_name == object.method(original_name).original_name
            end
          end
        end
      end
    end
  end
end

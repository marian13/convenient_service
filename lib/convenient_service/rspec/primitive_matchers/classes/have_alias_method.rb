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
          ##
          # @param alias_name [String, Symbol]
          # @param original_name [String, Symbol]
          # @return [void]
          #
          def initialize(alias_name, original_name)
            @alias_name = alias_name
            @original_name = original_name
          end

          ##
          # @param object [Object] Can be any type.
          # @return [Boolean]
          #
          def matches?(object)
            @object = object

            ##
            # TODO: Use `Utils::Object.duck_class` to support `have_alias_method` for classes.
            #
            return false unless Utils::Method.defined?(original_name, duck_class, private: true)

            return false unless Utils::Method.defined?(alias_name, duck_class, private: true)

            equal_methods?(alias_name, original_name)
          end

          ##
          # @return [String]
          #
          def description
            "have alias method `#{alias_name}` for `#{original_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{duck_class}` to have alias method `#{alias_name}` for `#{original_name}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{duck_class}` NOT to have alias method `#{alias_name}` for `#{original_name}`"
          end

          private

          ##
          # @!attribute [r] object
          #   @return [Object] Can be any type.
          #
          attr_reader :object

          ##
          # @!attribute [r] alias_name
          #   @return [String, Symbol]
          #
          attr_reader :alias_name

          ##
          # @!attribute [r] original_name
          #   @return [String, Symbol]
          #
          attr_reader :original_name

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
            ##
            # @param alias_name [String, Symbol]
            # @param original_name [String, Symbol]
            # @return [Boolean]
            #
            def equal_methods?(alias_name, original_name)
              alias_method_name = object.method(alias_name).original_name
              original_method_name = object.method(original_name).original_name

              return true if alias_method_name == original_method_name
              return true if alias_method_name.to_s == "@#{original_method_name}"

              false
            end
          else
            ##
            # @param alias_name [String, Symbol]
            # @param original_name [String, Symbol]
            # @return [Boolean]
            #
            def equal_methods?(alias_name, original_name)
              object.method(alias_name).original_name == object.method(original_name).original_name
            end
          end

          ##
          # @return [Class]
          #
          def duck_class
            @duck_class ||= ConvenientService::Utils::Object.duck_class(object)
          end
        end
      end
    end
  end
end

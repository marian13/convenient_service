# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
return unless ConvenientService::Dependencies.ruby.match?("jruby < 10.1")

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class HaveAliasMethod
          private

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
        end
      end
    end
  end
end

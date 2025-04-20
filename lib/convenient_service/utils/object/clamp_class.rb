# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# Returns class when `object` is a class, module when `object` is a module or object's class.
#
# @example Aloid `if` condition for `ConvenientService::Core::Concern::ClassMethod#middlewares`.
#
#   service = Service.new # || Service
#
#   if service.is_a?(Module)
#     service.middlewares(:result)
#   else
#     service.class.middelewares(:result)
#   end
#
#   ##
#   # With `ConvenientService::Utils::Object::clamp_class` it can be rewritten in the followiing way:
#   #
#   ConvenientService::Utils::Object::clamp_class(service).middlewares(:result)
#
# @example Possible returns values.
#
#   module Musician
#   end
#
#   class Person
#   end
#
#   person = Person.new
#
#   ConvenientService::Utils::Object::ClampClass.call(42)
#   # => Integer
#
#   ConvenientService::Utils::Object::ClampClass.call("foo")
#   # => String
#
#   ConvenientService::Utils::Object::ClampClass.call(person)
#   # => Person
#
#   ConvenientService::Utils::Object::ClampClass.call(Person)
#   # => Person
#
#   ConvenientService::Utils::Object::ClampClass.call(Musician)
#   # => Musician
#
# @note Name is inspired by `Comparable#clamp`.
#
# @see https://ruby-doc.org/core-2.7.0/Comparable.html#method-i-clamp
#
module ConvenientService
  module Utils
    module Object
      class ClampClass < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object]
        #
        attr_reader :object

        ##
        # @param object [Object]
        # @return [void]
        #
        def initialize(object)
          @object = object
        end

        ##
        # @return [Class]
        #
        def call
          object.is_a?(::Module) ? object : object.class
        end
      end
    end
  end
end

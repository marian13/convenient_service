# frozen_string_literal: true

##
# @example
#   module Musician
#   end
#
#   class Person
#   end
#
#   person = Person.new
#
#   ConvenientService::Utils::Object::ResolveClass.call(42)
#   # => Integer
#
#   ConvenientService::Utils::Object::ResolveClass.call("foo")
#   # => String
#
#   ConvenientService::Utils::Object::ResolveClass.call(person)
#   # => Person
#
#   ConvenientService::Utils::Object::ResolveClass.call(Person)
#   # => #<Class:Person>
#
#   ConvenientService::Utils::Object::ResolveClass.call(Musician)
#   # => #<Class:Musician>
#
module ConvenientService
  module Utils
    module Object
      class ResolveClass < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @param object [Object] Can be any type.
        #
        def initialize(object)
          @object = object
        end

        ##
        # @return [Class]
        #
        def call
          return object.singleton_class if object.is_a?(::Module)

          object.class
        end
      end
    end
  end
end

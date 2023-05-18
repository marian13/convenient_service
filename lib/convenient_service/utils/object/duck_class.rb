# frozen_string_literal: true

##
# Converts an object to a "duck" class in terms of `Module#method_defined?` or `Module#define_method`.
#
# @example Avoid `if` condition for `Module#method_defined?`.
#
#   object = Person.new # || Person
#
#   if object.is_a?(Module)
#     ##
#     # class Person
#     #   def self.foo
#     #   end
#     # end
#     #
#     # Does `Person` has class method `foo`?
#     #
#     object.singleton_class.method_defined?(:foo)
#   else
#     ##
#     # class Person
#     #   def foo
#     #   end
#     # end
#     #
#     # Does `Person` has instance method `foo`?
#     #
#     object.class.method_defined?(:foo)
#   end
#
#   ##
#   # With `ConvenientService::Utils::Object.duck_class` it can be rewritten in the following way:
#   #
#   ConvenientService::Utils::Object.duck_class(object).method_defined?(:foo)
#
# @example Avoid `if` condition for `Module#define_method`.
#
#   object = Person.new # || Person
#
#   if object.is_a?(Module)
#     ##
#     # Defines class method `foo` in `Person` class.
#     #
#     object.singleton_class.define_method(:foo) { :bar }
#   else
#     ##
#     # Defines instance method `foo` in `Person` class.
#     #
#     object.class.define_method(:foo) { :bar }
#   end
#
#   ##
#   # With `ConvenientService::Utils::Object.duck_class` it can be rewritten in the following way:
#   #
#   ConvenientService::Utils::Object.duck_class(object).define_method(:foo) { :bar }
#
# @example Possible return values.
#
#   module Musician
#   end
#
#   class Person
#   end
#
#   person = Person.new
#
#   ConvenientService::Utils::Object::DuckClass.call(42)
#   # => Integer
#
#   ConvenientService::Utils::Object::DuckClass.call("foo")
#   # => String
#
#   ConvenientService::Utils::Object::DuckClass.call(person)
#   # => Person
#
#   ConvenientService::Utils::Object::DuckClass.call(Person)
#   # => #<Class:Person>
#
#   ConvenientService::Utils::Object::DuckClass.call(Musician)
#   # => #<Class:Musician>
#
module ConvenientService
  module Utils
    module Object
      ##
      # TODO: A better name.
      #
      class DuckClass < Support::Command
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
          object.is_a?(::Module) ? object.singleton_class : object.class
        end
      end
    end
  end
end

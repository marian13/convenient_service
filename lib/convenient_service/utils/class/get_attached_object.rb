# frozen_string_literal: true

##
# @note This util is only available for Ruby 3.2+. There are no reliable and performant backports for older Rubies.
#
# @see https://github.com/marcandre/backports/blob/v3.25.0/lib/backports/3.2.0/class/attached_object.rb#L7
# @see https://github.com/panorama-ed/memo_wise/blob/v1.9.0/lib/memo_wise/internal_api.rb#L222
# @see https://bugs.ruby-lang.org/issues/12084
# @see https://stackoverflow.com/questions/54531270/retrieve-a-ruby-object-from-its-singleton-class
#
# @example Usual class.
#   ConvenientService::Utils::Class::GetAttachedObject.call(String)
#   # => nil
#
# @example Singleton class.
#   ConvenientService::Utils::Class::GetAttachedObject.call(String.singleton_class)
#   # => String
#
# @example Usual module.
#   ConvenientService::Utils::Class::GetAttachedObject.call(Kernel)
#   # => nil
#
# @example Singleton module.
#   ConvenientService::Utils::Class::GetAttachedObject.call(Kernel.singleton_class)
#   # => Kernel
#
# @example Usual instance.
#   ConvenientService::Utils::Class::GetAttachedObject.call("abc")
#   # => nil
#
# @example Singleton instance.
#   ConvenientService::Utils::Class::GetAttachedObject.call("abc".singleton_class)
#   # => "abc"
#
return if ConvenientService::Dependencies.ruby.version < 3.2

module ConvenientService
  module Utils
    module Class
      class GetAttachedObject < Support::Command
        ##
        # @api private
        #
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :klass

        ##
        # @api private
        #
        # @param klass [Class]
        # @return [void]
        #
        def initialize(klass)
          @klass = klass
        end

        ##
        # @api private
        #
        # @return [Class, nil]
        #
        def call
          return unless klass
          return unless klass.is_a?(::Module)
          return unless klass.singleton_class?

          klass.attached_object
        end
      end
    end
  end
end

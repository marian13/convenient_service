# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Utils
    module Module
      ##
      # Returns parent namespace of class or module.
      #
      # @api private
      # @since 1.0.0
      #
      # @example Common usage.
      #   module Foo
      #     module Bar
      #       class Baz
      #       end
      #     end
      #   end
      #
      #   ConvenientService::Utils::Module::GetNamespace.call(Foo)
      #   # => nil
      #
      #   ConvenientService::Utils::Module::GetNamespace.call(Foo::Bar)
      #   # => Foo
      #
      #   ConvenientService::Utils::Module::GetNamespace.call(Foo::Bar::Baz)
      #   # => Foo::Bar
      #
      #   ConvenientService::Utils::Module::GetNamespace.call(Module.new)
      #   # => nil
      #
      class GetNamespace < Support::Command
        ##
        # @!attribute [r] mod
        #   @return [Class, Module]
        #
        attr_reader :mod

        ##
        # @param mod [Class, Module]
        # @return [void]
        #
        def initialize(mod)
          @mod = mod
        end

        ##
        # @return [Module, Class, nil]
        # @raise [ConvenientService::Utils::Module::Exceptions::NestingUnderAnonymousNamespace]
        #
        def call
          return unless mod.name
          return unless mod.name.include?("::")

          namespace_name = mod.name.split("::")[0..-2].join("::")

          begin
            ::Object.const_get(namespace_name, false)
          rescue ::NameError
            ::ConvenientService.raise Exceptions::NestingUnderAnonymousNamespace.new(mod: mod, namespace: namespace_name)
          end
        end
      end
    end
  end
end

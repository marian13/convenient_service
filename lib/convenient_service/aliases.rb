# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @internal
#   NOTE: Aliases hide the full constants path from the end-users in order to increase DX.
#   - https://en.wikipedia.org/wiki/User_experience#Developer_experience
##

module ConvenientService
  ##
  # Convenient Service command (aka operation without results and steps).
  # Useful for utils that are always "successful".
  #
  # @api public
  # @since 1.0.0
  # @return [Class]
  #
  # @example Common usage.
  #   class ToBool < ConvenientService::Command
  #     attr_reader :object
  #
  #     def initialize(object)
  #       @object = object
  #     end
  #
  #     def call
  #       !!object
  #     end
  #   end
  #
  #   ToBool.new(42).call
  #   # => true
  #
  #   ToBool.call(42)
  #   # => true
  #
  #   ToBool.(42)
  #   # => true
  #
  #   ToBool[42]
  #   # => true
  #
  # @example No need to define class `call` method.
  #   class Command < ConvenientService::Command
  #     # ...
  #
  #     ##
  #     # Class `call` method in already defined in `ConvenientService::Command` like so:
  #     #
  #     # def call(...)
  #     #   new.call(...)
  #     # end
  #     ##
  #
  #     # ...
  #   end
  #
  Command = ::ConvenientService::Support::Command

  ##
  # Convenient Service concern (Like Rails concern, but with some customizations).
  #
  # @api public
  # @since 1.0.0
  # @return [Module]
  #
  # @note Expected to be used from Convenient Service plugins.
  #
  Concern = ::ConvenientService::Support::Concern

  ##
  # Convenient Service dependency container.
  #
  # @api public
  # @since 1.0.0
  # @return [Module]
  #
  # @example Common usage.
  #   module Container
  #     include ConvenientService::DependencyContainer::Export
  #
  #     export "foo" do |*args|
  #       "foo"
  #     end
  #
  #     export :bar do |**kwargs|
  #       "bar"
  #     end
  #
  #     export :baz do |&block|
  #       "baz"
  #     end
  #   end
  #
  #   class User
  #     include ConvenientService::DependencyContainer::Import
  #
  #     import :foo, from: Container
  #     import "bar", as: :custom_bar, from: Container
  #     import :baz, as: "namespaced.baz", from: Container
  #   end
  #
  #   User.new.foo
  #   # => "foo"
  #
  #   User.new.custom_bar
  #   # => "bar"
  #
  #   User.new.namespaced.baz
  #   # => "baz"
  #
  DependencyContainer = ::ConvenientService::Support::DependencyContainer

  ##
  # Convenient Service base result class. Useful as a shortcut for result utilities.
  #
  # @api public
  # @since 1.0.0
  # @return [Class]
  #
  # @example How to check whether an object is a result?
  #   ConvenintService::Result.result?(some_object)
  #
  Result = ::ConvenientService::Service::Plugins::HasJSendResult::Entities::Result
end

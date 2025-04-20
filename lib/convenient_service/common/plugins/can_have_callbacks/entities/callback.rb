# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Entities
          class Callback
            ##
            # @!attribute [r] types
            #   @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::TypeCollection]
            #
            attr_reader :types

            ##
            # @!attribute [r] block
            #   @return [Proc]
            #
            attr_reader :block

            ##
            # @!attribute [r] source_location
            #   @return [String]
            #
            attr_reader :source_location

            ##
            # @param types [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::TypeCollection]
            # @param block [Proc, nil]
            # @param extra_kwargs [Hash{Symbol => Object}]
            # @return [void]
            #
            def initialize(types:, block:, **extra_kwargs)
              @types = Entities::TypeCollection.new(types: types)
              @block = block
              @source_location = extra_kwargs.fetch(:source_location) { block.source_location }
            end

            ##
            # @return [String]
            #
            # @internal
            #   TODO: Util.
            #
            def source_location_joined_by_colon
              source_location.join(":")
            end

            ##
            # @return [Boolean]
            #
            def called?
              Utils.to_bool(@called)
            end

            ##
            # @return [Boolean]
            #
            def not_called?
              !called?
            end

            ##
            # @return [Object] Can be any type.
            #
            def call(...)
              call_callback(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            alias_method :yield, :call

            ##
            # @return [Object] Can be any type.
            #
            alias_method :[], :call

            ##
            # @return [Object] Can be any type.
            #
            alias_method :===, :call

            ##
            # @param context [Object] Can be any type.
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def call_in_context(context)
              call_callback_in_context(context)
            end

            ##
            # @param context [Object] Can be any type.
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def call_in_context_with_arguments(context, *args, **kwargs, &block)
              call_callback_in_context(context, arguments(*args, **kwargs, &block))
            end

            ##
            # @param context [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            #
            def call_in_context_with_value_and_arguments(context, value, *args, **kwargs, &block)
              call_callback_in_context(context, value, arguments(*args, **kwargs, &block))
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if types != other.types
              return false if block != other.block
              return false if source_location != other.source_location

              true
            end

            ##
            # @return [Proc]
            #
            def to_proc
              block
            end

            private

            ##
            # @return [Boolean]
            #
            # @internal
            #   FIX: What if method is executed second time? Callback `called` status is NOT reset.
            #
            def mark_as_called
              @called = true
            end

            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def arguments(...)
              Support::Arguments.new(...)
            end

            ##
            # @return [Object] Can be any type.
            #
            def call_callback(...)
              block.call(...).tap { mark_as_called }
            end

            ##
            # @param context [Object] Can be any type.
            # @param args [Array<Object>]
            # @return [Object] Can be any type.
            #
            # @internal
            #   FIX: `mark_as_called`.
            #
            def call_callback_in_context(context, *args)
              context.instance_exec(*args, &block).tap { mark_as_called }
            end
          end
        end
      end
    end
  end
end

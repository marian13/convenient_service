# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class Callback
            ##
            # @!attribute [r] types
            #   @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection]
            #
            attr_reader :types

            ##
            # @!attribute [r] block
            #   @return [Proc]
            #
            attr_reader :block

            ##
            # @param types [ConvenientService::Common::Plugins::HasCallbacks::Entities::TypeCollection]
            # @param block [Proc]
            # @return [void]
            #
            def initialize(types:, block:)
              @types = Entities::TypeCollection.new(types: types)
              @block = block
            end

            ##
            # @return [Boolean]
            #
            def called?
              Utils::Bool.to_bool(@called)
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
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def call_in_context(context)
              call_callback_in_context(context)
            end

            ##
            # @param context [Object] Can be any type.
            # @param args [Array]
            # @param kwargs [Hash]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def call_in_context_with_arguments(context, *args, **kwargs, &block)
              call_callback_in_context(context, arguments(*args, **kwargs, &block))
            end

            ##
            # @param context [Object] Can be any type.
            # @param value [Object] Can be any type.
            # @param args [Array]
            # @param kwargs [Hash]
            # @param block [Proc]
            # @return [ConvenientService::Common::Plugins::HasCallbacks::Entities::Callback]
            #
            def call_in_context_with_value_and_arguments(context, value, *args, **kwargs, &block)
              call_callback_in_context(context, value, arguments(*args, **kwargs, &block))
            end

            ##
            # @param other [Object] Can be any type.
            # @return [Boolead]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if types != other.types
              return false if block&.source_location != other.block&.source_location

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
            # @return [Object] Can be any type.
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

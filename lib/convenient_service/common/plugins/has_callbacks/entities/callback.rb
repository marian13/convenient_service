# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class Callback
            attr_reader :types, :block

            def initialize(types:, block:)
              @types = Entities::TypeCollection.new(types: types)
              @block = block
            end

            def called?
              Utils::Bool.to_bool(@called)
            end

            def not_called?
              !called?
            end

            def call(*args, **kwargs)
              block.call(*args, **kwargs).tap { mark_as_called }
            end

            alias_method :yield, :call
            alias_method :[], :call
            alias_method :===, :call

            def call_in_context(context, *args, **kwargs)
              context.instance_exec(*args, **kwargs, &block).tap { mark_as_called }
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              return false if types != other.types
              return false if block&.source_location != other.block&.source_location

              true
            end

            def to_proc
              block
            end

            private

            def mark_as_called
              @called = true
            end
          end
        end
      end
    end
  end
end

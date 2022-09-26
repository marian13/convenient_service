# frozen_string_literal: true

require_relative "type/class_methods"

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        module Entities
          class Type
            include Support::Castable
            include Support::Delegate

            extend ClassMethods

            attr_reader :value

            delegate :hash, to: :value

            def initialize(value:)
              @value = value
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              return false if value != other.value

              true
            end

            ##
            # NOTE: Used by `contain_exactly`. Check its specs.
            #
            # NOTE: This method is intented to be used only for hash keys comparison,
            # when you know for sure that `other` is always an `Entities::Type` instance.
            #
            # IMPORTANT: Do NOT use `eql?` without a strong reason, prefer `==`.
            #
            def eql?(other)
              return unless other.instance_of?(self.class)

              hash == other.hash
            end
          end
        end
      end
    end
  end
end

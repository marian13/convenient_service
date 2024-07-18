# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Entities
          class TypeCollection
            attr_reader :types

            def initialize(types:)
              @types = types.map(&Entities::Type.method(:cast!))
            end

            def contain_exactly?(other_types)
              other_types = other_types.map(&Entities::Type.method(:cast!))

              Utils::Array.contain_exactly?(types, other_types)
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              return false if types != other.types

              true
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Entities
          class ID
            def initialize(value:)
              @value = value
            end

            class << self
              def cast(value)
                new(value: value.to_s)
              end
            end

            def exist?
              to_i % 2 == 0
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              value == other.value
            end

            def to_i
              value.to_i
            end

            def to_s
              value
            end

            protected

            attr_reader :value
          end
        end
      end
    end
  end
end

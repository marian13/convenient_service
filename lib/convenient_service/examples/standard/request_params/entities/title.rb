# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Entities
          class Title
            def initialize(value:)
              @value = value
            end

            class << self
              def cast(value)
                new(value: value.to_s)
              end
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              value == other.value
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

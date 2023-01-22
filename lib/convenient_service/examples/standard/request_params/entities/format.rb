# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module RequestParams
        module Entities
          class Format
            def initialize(value:)
              @value = value
            end

            class << self
              def cast(value)
                case value
                when ::String
                  new(value: value.to_s)
                end
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

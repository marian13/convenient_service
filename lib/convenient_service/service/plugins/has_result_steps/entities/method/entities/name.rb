# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              class Name
                include Support::Copyable
                include Support::Delegate

                attr_reader :value

                delegate :to_s, :to_sym, to: :value

                def initialize(value)
                  @value = value
                end

                def ==(other)
                  return unless other.instance_of?(self.class)

                  return false if value != other.value

                  true
                end

                def to_args
                  [value]
                end
              end
            end
          end
        end
      end
    end
  end
end

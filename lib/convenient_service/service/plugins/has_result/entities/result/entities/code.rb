# frozen_string_literal: true

require_relative "code/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Entities
              class Code
                include Support::Castable

                extend ClassMethods

                attr_reader :value

                def initialize(value:)
                  @value = value
                end

                def ==(other)
                  casted = cast(other)

                  return unless casted

                  value == casted.value
                end

                def to_s
                  @to_s ||= value.to_s
                end

                def to_sym
                  @to_sym ||= value.to_sym
                end

                ##
                # TODO: Unify `inspect'. Specs for `inspect'.
                #
              end
            end
          end
        end
      end
    end
  end
end

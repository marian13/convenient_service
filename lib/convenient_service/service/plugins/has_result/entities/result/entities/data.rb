# frozen_string_literal: true

require_relative "data/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Entities
              class Data
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

                def [](key)
                  value.fetch(key.to_sym) { raise Errors::NotExistingAttribute.new(attribute: key) }
                end

                def to_h
                  @to_h ||= value.to_h
                end

                ##
                # TODO: Unify `inspect`. Specs for `inspect`.
                #
                def inspect
                  to_h.inspect
                end
              end
            end
          end
        end
      end
    end
  end
end

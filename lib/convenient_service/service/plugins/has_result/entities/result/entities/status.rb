# frozen_string_literal: true

require_relative "status/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Entities
              class Status
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

                def success?
                  value == :success
                end

                def failure?
                  value == :failure
                end

                def error?
                  value == :error
                end

                def not_success?
                  !success?
                end

                def not_failure?
                  !failure?
                end

                def not_error?
                  !error?
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

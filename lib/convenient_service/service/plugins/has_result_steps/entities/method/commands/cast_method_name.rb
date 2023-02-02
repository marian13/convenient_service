# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Commands
              #
              # TODO: Abstract factory.
              #
              class CastMethodName < Support::Command
                attr_reader :other, :options

                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                def call
                  ##
                  # TODO: Use pattern matcher when Ruby 2.7.
                  #
                  case other
                  when ::Symbol then cast_symbol
                  when ::String then cast_string
                  when ::Hash then cast_hash
                  when Entities::Values::Reassignment then cast_reassignment
                  when Method then cast_method
                  end
                end

                private

                def cast_symbol
                  Entities::Name.new(other)
                end

                def cast_string
                  Entities::Name.new(other)
                end

                def cast_reassignment
                  Entities::Name.new(other.to_sym)
                end

                def cast_hash
                  return unless other.keys.one?

                  key = other.keys.first
                  value = other.values.first

                  case value
                  when ::Symbol
                    Entities::Name.new(value)
                  when ::String
                    Entities::Name.new(value)
                  when ::Proc
                    Entities::Name.new(key)
                  when Support::RawValue
                    Entities::Name.new(key)
                  when Entities::Values::Reassignment
                    Entities::Name.new(value.to_sym)
                  end
                end

                def cast_method
                  other.name.copy
                end
              end
            end
          end
        end
      end
    end
  end
end

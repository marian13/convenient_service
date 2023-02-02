# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Commands
              ##
              # TODO: Abstract factory.
              #
              class CastMethodKey < Support::Command
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
                  Entities::Key.new(other)
                end

                def cast_string
                  Entities::Key.new(other)
                end

                def cast_reassignment
                  Entities::Key.new(other.to_sym)
                end

                def cast_hash
                  return unless other.keys.one?

                  key = other.keys.first
                  value = other.values.first

                  case value
                  when ::Symbol
                    Entities::Key.new(key)
                  when ::String
                    Entities::Key.new(key)
                  when ::Proc
                    Entities::Key.new(key)
                  when Support::RawValue
                    Entities::Key.new(key)
                  when Entities::Values::Reassignment
                    Entities::Key.new(key)
                  end
                end

                def cast_method
                  other.key.copy
                end
              end
            end
          end
        end
      end
    end
  end
end

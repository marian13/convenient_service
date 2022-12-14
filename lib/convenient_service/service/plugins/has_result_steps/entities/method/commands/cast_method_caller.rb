# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Commands
              ##
              # TODO: Replace `CastMethodKey`, `CastMethodName`, `CastMethodCaller` by declarative caster?
              #
              class CastMethodCaller < Support::Command
                attr_reader :other, :options

                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                def call
                  case other
                  when ::Symbol then cast_symbol
                  when ::String then cast_string
                  when ::Hash then cast_hash
                  when Method then cast_method
                  end
                end

                private

                def cast_symbol
                  Entities::Callers::Usual.new(other)
                end

                def cast_string
                  Entities::Callers::Usual.new(other)
                end

                def cast_hash
                  return unless other.keys.one?

                  value = other.values.first

                  case value
                  when ::Symbol
                    Entities::Callers::Alias.new(value)
                  when ::String
                    Entities::Callers::Alias.new(value)
                  when ::Proc
                    Entities::Callers::Proc.new(value)
                  when Support::RawValue
                    Entities::Callers::Raw.new(value)
                  end
                end

                def cast_method
                  other.caller.copy
                end
              end
            end
          end
        end
      end
    end
  end
end

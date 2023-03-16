# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              ##
              # TODO: Abstract factory.
              #
              class CastMethodDirection < Support::Command
                attr_reader :other, :options

                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                def call
                  casted =
                    case options[:direction]
                    when ::Symbol then cast_symbol
                    when ::String then cast_string
                    end

                  ##
                  # TODO: Specs. Priority.
                  #
                  return casted if casted

                  case other
                  when Method then cast_method
                  end
                end

                private

                def cast_symbol
                  case options[:direction]
                  when :input
                    Entities::Directions::Input.new
                  when :output
                    Entities::Directions::Output.new
                  end
                end

                def cast_string
                  case options[:direction]
                  when "input"
                    Entities::Directions::Input.new
                  when "output"
                    Entities::Directions::Output.new
                  end
                end

                def cast_method
                  other.direction.copy
                end
              end
            end
          end
        end
      end
    end
  end
end

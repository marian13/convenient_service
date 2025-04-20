# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              ##
              # @internal
              #   TODO: Separate in and out methods?
              #
              class CastMethodDirection < Support::Command
                ##
                # @!attribute [r] options
                #   @return [Object] Can be any type.
                #
                attr_reader :other

                ##
                # @!attribute [r] options
                #   @return [Hash]
                #
                attr_reader :options

                ##
                # @param other [Object] Can be any type.
                # @param options [Hash]
                #
                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                ##
                # @return [Entities::Directions::Base, nil]
                #
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

                ##
                # @return [Entities::Directions::Base, nil]
                #
                def cast_symbol
                  case options[:direction]
                  when :input
                    Entities::Directions::Input.new
                  when :output
                    Entities::Directions::Output.new
                  end
                end

                ##
                # @return [Entities::Directions::Base, nil]
                #
                def cast_string
                  case options[:direction]
                  when "input"
                    Entities::Directions::Input.new
                  when "output"
                    Entities::Directions::Output.new
                  end
                end

                ##
                # @return [Entities::Directions::Base, nil]
                #
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

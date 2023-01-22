# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Values
                ##
                # TODO: Specs.
                #
                class Reassignment
                  include Support::Delegate

                  attr_reader :value

                  delegate :to_s, :to_sym, to: :value

                  ##
                  # @param value [String, Symbol] Method name to reassign.
                  #
                  def initialize(value)
                    @value = value
                  end

                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if value != other.value

                    true
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

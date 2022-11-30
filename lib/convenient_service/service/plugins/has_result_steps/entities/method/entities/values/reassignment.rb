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
                  attr_reader :method_name

                  def initialize(method_name)
                    @method_name = method_name
                  end

                  def ==(other)
                    return unless other.instance_of?(self.class)

                    method_name == other.method_name
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

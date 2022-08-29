# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Directions
                class Base
                  include Support::AbstractMethod
                  include Support::Copyable

                  abstract_method \
                    :validate_as_input_for_container!,
                    :validate_as_output_for_container!,
                    :define_output_in_container!

                  def ==(other)
                    return unless other.instance_of?(self.class)

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

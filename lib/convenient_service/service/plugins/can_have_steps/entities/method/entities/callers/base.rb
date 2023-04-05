# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Base
                  include Support::AbstractMethod
                  include Support::Copyable

                  ##
                  # TODO: A better name for `object`. Wrapped object, `target`?
                  #
                  attr_reader :object

                  abstract_method \
                    :calculate_value,
                    :validate_as_input_for_container!,
                    :validate_as_output_for_container!,
                    :define_output_in_container!

                  def initialize(object)
                    @object = object
                  end

                  def reassignment?(name)
                    false
                  end

                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if object != other.object

                    true
                  end

                  def to_args
                    [object]
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

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
                class Raw
                  def initialize(object)
                    @object = object
                  end

                  class << self
                    def wrap(object)
                      new(object)
                    end

                    private :new
                  end

                  def unwrap
                    object
                  end

                  def ==(other)
                    return unless other.instance_of?(self.class)

                    object == other.object
                  end

                  protected

                  attr_reader :object
                end
              end
            end
          end
        end
      end
    end
  end
end

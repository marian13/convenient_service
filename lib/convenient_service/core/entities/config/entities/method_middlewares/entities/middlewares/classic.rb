# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                ##
                # @abstract Subclass and override `#call`.
                #
                # @internal
                #   NOTE: Do NOT pollute the interface of this class until really needed.
                #   Avoid even pollution of private methods.
                #   This way there is a lower risk that a plugin developer accidentally overwrites an internal middleware behavior.
                #   https://github.com/Ibsciss/ruby-middleware#a-basic-example
                #
                class Classic < Middlewares::Base
                  ##
                  # @return [Object] Can be any type.
                  #
                  def call(env)
                    stack.call(env)
                  end

                  ##
                  # @return [#call<Hash>]
                  #
                  def stack
                    @__stack__
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

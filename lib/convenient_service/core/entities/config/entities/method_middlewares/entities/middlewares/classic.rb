# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                ##
                # Class `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic` allows to define middlewares that interacts with `call` and `env` directly.
                # For example `ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain::Commands::NormalizeEnv` was implemeted as middleware up to v0.18.
                #
                #   class Middleware < MethodClassicMiddleware
                #     intended_for any_method, scope: any_scope, entity: any_entity
                #
                #     def call(env = nil)
                #       env = env.to_h
                #       env = env.merge(args: env[:args].to_a, kwargs: env[:kwargs].to_h, block: env[:block])
                #
                #       stack.call(env)
                #     end
                #   end
                #
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

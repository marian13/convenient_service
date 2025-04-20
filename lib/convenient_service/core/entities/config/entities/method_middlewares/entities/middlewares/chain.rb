# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "chain/commands"
require_relative "chain/concern"
require_relative "chain/entities"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                ##
                # @abstract Subclass and override `#next`.
                #
                # @internal
                #   NOTE: Do NOT pollute the interface of this class until really needed.
                #   Avoid even pollution of private methods.
                #   This way there is a lower risk that a plugin developer accidentally overwrites an internal middleware behavior.
                #   https://github.com/Ibsciss/ruby-middleware#a-basic-example
                #
                class Chain < Middlewares::Base
                  include Concern
                end
              end
            end
          end
        end
      end
    end
  end
end

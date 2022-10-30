# frozen_string_literal: true

require_relative "caller/commands"
require_relative "caller/concern"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                INSTANCE_PREFIX = "self.class."
                CLASS_PREFIX = ""

                include Concern
              end
            end
          end
        end
      end
    end
  end
end

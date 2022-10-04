# frozen_string_literal: true

require_relative "caller/commands"

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Caller
            class << self
              def resolve_super_method(entity, scope, method)
                Commands::ResolveSuperMethod.call(entity: entity, scope: scope, method: method)
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Concern
              module ClassMethods
                ##
                # @param other [Hash, ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container, nil]
                #
                def cast(other)
                  Commands::CastContainer.call(other: other)
                end
              end
            end
          end
        end
      end
    end
  end
end

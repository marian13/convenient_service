# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Caller
                module Concern
                  module ClassMethods
                    ##
                    # @param other [Hash, ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller]
                    # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Caller, nil]
                    #
                    def cast(other)
                      Commands::CastCaller.call(other: other)
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
end

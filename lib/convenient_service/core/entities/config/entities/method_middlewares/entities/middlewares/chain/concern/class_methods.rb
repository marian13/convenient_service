# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Chain < Middlewares::Base
                  module Concern
                    module ClassMethods
                      ##
                      # @return [Class]
                      #
                      def chain_class
                        Entities::MethodChain
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
end

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
                class Chain < Middlewares::Base
                  module Concern
                    module ClassMethods
                      ##
                      # @return [Class]
                      #
                      def chain_class
                        Entities::MethodChain
                      end

                      ##
                      # @return [Class]
                      #
                      def to_observable_middleware
                        Commands::CreateObservableMiddleware.call(middleware: super)
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

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
          class Concerns
            module Usual
              class << self
                ##
                # @param mod [Module]
                # @return [void]
                #
                def included(mod)
                  mod.extend Dependencies::Extractions::ActiveSupportConcern::Concern

                  mod.module_exec do
                    class << self
                      ##
                      # @param option [ConvenientService::Config::Entities::Option]
                      # @param detail_keys [Array<Symbol>]
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                      #
                      def from(option, *detail_keys)
                        ::ConvenientService::Core::Entities::Config::Commands::BuildEntityFromConfigOption.call(base_entity: self, option: option, detail_keys: detail_keys)
                      end

                      ##
                      # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::With]
                      #
                      def with(...)
                        self
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

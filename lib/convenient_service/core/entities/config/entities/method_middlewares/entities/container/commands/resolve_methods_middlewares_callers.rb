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
              class Container
                module Commands
                  class ResolveMethodsMiddlewaresCallers < Support::Command
                    include Support::Delegate

                    ##
                    # @!attribute [r] container
                    #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    #
                    attr_reader :container

                    ##
                    # @return [Class]
                    #
                    delegate :klass, to: :container

                    ##
                    # @param container [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [void]
                    #
                    def initialize(container:)
                      @container = container
                    end

                    ##
                    # @return [Module]
                    #
                    def call
                      Utils::Module.fetch_own_const(klass, :MethodsMiddlewaresCallers) { ::Module.new }
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

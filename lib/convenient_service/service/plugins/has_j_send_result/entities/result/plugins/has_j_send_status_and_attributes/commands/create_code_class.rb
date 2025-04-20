# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Commands
                  class CreateCodeClass < Support::Command
                    include Support::DependencyContainer::Import

                    ##
                    # @!attribute [r] result_class
                    #   @return Class
                    #
                    attr_reader :result_class

                    ##
                    # @return Class
                    #
                    import :"commands.FindOrCreateEntity", from: Common::Plugins::CanHaveUserProvidedEntity::Container

                    ##
                    # @param result_class [Class]
                    # @return [void]
                    #
                    def initialize(result_class:)
                      @result_class = result_class
                    end

                    ##
                    # @return [Class]
                    #
                    def call
                      commands.FindOrCreateEntity.call(namespace: result_class, proto_entity: Entities::Code)
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

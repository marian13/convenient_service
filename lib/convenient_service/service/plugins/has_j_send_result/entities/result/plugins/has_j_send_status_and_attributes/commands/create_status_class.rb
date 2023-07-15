# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Commands
                  class CreateStatusClass < Support::Command
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
                      commands.FindOrCreateEntity.call(namespace: result_class, proto_entity: Entities::Status)
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

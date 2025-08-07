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
                module Concern
                  module ClassMethods
                    ##
                    # @api private
                    # @return [Class]
                    #
                    def code_class
                      @code_class ||= Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity[
                        namespace: self,
                        proto_entity: Entities::Code
                      ]
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    def data_class
                      @data_class ||= Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity[
                        namespace: self,
                        proto_entity: Entities::Data
                      ]
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    def message_class
                      @message_class ||= Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity[
                        namespace: self,
                        proto_entity: Entities::Message
                      ]
                    end

                    ##
                    # @api private
                    # @return [Class]
                    #
                    def status_class
                      @status_class ||= Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity[
                        namespace: self,
                        proto_entity: Entities::Status
                      ]
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

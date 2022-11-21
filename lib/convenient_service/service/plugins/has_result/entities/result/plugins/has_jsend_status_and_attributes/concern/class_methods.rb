# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Concern
                  module ClassMethods
                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    def create(...)
                      new(...)
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

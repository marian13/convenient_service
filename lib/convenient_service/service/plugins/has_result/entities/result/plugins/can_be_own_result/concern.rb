# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanBeOwnResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @param service [ConvenientService::Service]
                    # @return [Boolean]
                    #
                    def own_result_for?(service)
                      self.service.equal?(service)
                    end

                    ##
                    # @param service [ConvenientService::Service]
                    # @return [Boolean]
                    #
                    def foreign_result_for?(service)
                      !own_result_for?(service)
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

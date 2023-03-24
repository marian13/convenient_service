# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Factories
                module Hash
                  class RawValue < Factories::Hash::Base
                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                    #
                    def create_key
                      Entities::Key.new(key)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                    #
                    def create_name
                      Entities::Name.new(key)
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Caller]
                    #
                    def create_caller
                      Entities::Callers::Raw.new(value)
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

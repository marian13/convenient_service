# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Service
            module Concern
              module ClassMethods
                ##
                # @param other [Object] Can be any type.
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service, nil]
                #
                def cast(other)
                  case other
                  when ::Class then cast_klass(other)
                  when Service then cast_service(other)
                  end
                end

                private

                ##
                # @param klass [Class]
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                def cast_klass(klass)
                  new(klass)
                end

                ##
                # @param service [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                def cast_service(service)
                  new(service.klass)
                end
              end
            end
          end
        end
      end
    end
  end
end

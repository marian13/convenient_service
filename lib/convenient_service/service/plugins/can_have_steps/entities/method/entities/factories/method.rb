# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Factories
                class Method < Factories::Base
                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                  #
                  def create_key
                    other.key.copy
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                  #
                  def create_name
                    other.name.copy
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Caller]
                  #
                  def create_caller
                    other.caller.copy
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

# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Factories
                class Reassignment < Factories::Base
                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                  #
                  def create_key
                    Entities::Key.new(other.to_sym)
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                  #
                  def create_name
                    Entities::Name.new(other.to_sym)
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Caller]
                  #
                  def create_caller
                    Entities::Callers::Reassignment.new(other)
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

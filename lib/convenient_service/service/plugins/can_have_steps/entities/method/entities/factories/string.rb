# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Factories
                class String < Factories::Base
                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                  #
                  def create_key
                    Entities::Key.new(other)
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                  #
                  def create_name
                    Entities::Name.new(other)
                  end

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base]
                  #
                  def create_caller
                    Entities::Callers::Usual.new(other)
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

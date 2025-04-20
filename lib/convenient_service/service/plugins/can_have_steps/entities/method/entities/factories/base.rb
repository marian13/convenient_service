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
                class Base
                  include Support::AbstractMethod

                  ##
                  # @!attribute [r] other
                  #   @return [Object] Can be any type.
                  #
                  attr_reader :other

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                  #
                  abstract_method :create_key

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                  #
                  abstract_method :create_name

                  ##
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Callers::Base]
                  #
                  abstract_method :create_caller

                  ##
                  # @param other [Object] Can be any type.
                  # @return [void]
                  #
                  def initialize(other:)
                    @other = other
                  end

                  ##
                  # @param other [Object] Can be any type.
                  # @return [Boolean, nil]
                  #
                  def ==(other)
                    return unless other.instance_of?(self.class)

                    return false if self.other != other.other

                    true
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

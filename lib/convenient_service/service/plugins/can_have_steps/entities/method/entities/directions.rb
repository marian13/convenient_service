# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "directions/base"
require_relative "directions/input"
require_relative "directions/output"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Entities
              module Directions
                include Support::Castable

                class << self
                  ##
                  # @param other [String, Symbol, nil]
                  # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Direction::Base, nil]
                  #
                  def cast(other)
                    case other
                    when :input, "input", nil
                      Entities::Directions::Input.new
                    when :output, "output"
                      Entities::Directions::Output.new
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

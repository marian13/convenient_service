# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "failure/commands"

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              module Printers
                ##
                # @internal
                #   IMPORTANT: Do NOT forget to update the `Null` printer every time when the public interface is changed.
                #
                class Failure < Printers::Base
                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_jsend_attributes_part
                    Commands::GenerateGotJsendAttributesPart[printer: self]
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

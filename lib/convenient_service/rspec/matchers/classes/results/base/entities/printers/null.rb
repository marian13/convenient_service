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
                class Null < Printers::Base
                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def description
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def failure_message
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def failure_message_when_negated
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_parts
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_parts
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_code_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_data_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_message_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_service_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_status_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def expected_step_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_step_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_service_part
                    ""
                  end

                  ##
                  # @api private
                  #
                  # @return [String]
                  #
                  def got_jsend_attributes_part
                    ""
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

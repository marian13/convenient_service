# frozen_string_literal: true

require_relative "success/commands"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Entities
              module Printers
                class Success < Printers::Base
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

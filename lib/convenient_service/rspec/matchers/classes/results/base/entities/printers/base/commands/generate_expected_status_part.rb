# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Entities
              module Printers
                class Base
                  module Commands
                    class GenerateExpectedStatusPart < Support::Command
                      include Support::Delegate

                      ##
                      # @api private
                      #
                      # @!attribute printer [r]
                      #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
                      #
                      attr_reader :printer

                      ##
                      # @api private
                      #
                      # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain]
                      #
                      delegate :chain, to: :printer

                      ##
                      # @api private
                      #
                      # @param printer [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Printers::Base]
                      # @return [void]
                      #
                      def initialize(printer:)
                        @printer = printer
                      end

                      ##
                      # @api private
                      #
                      # @return [String]
                      #
                      def call
                        "with #{printable_statuses} status"
                      end

                      private

                      ##
                      # @return [String]
                      #
                      def printable_statuses
                        chain.statuses.map { |status| "`#{status}`" }.join(" or ")
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
end

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
              class Validator
                module Commands
                  class ValidateResultType < Support::Command
                    include Support::Delegate

                    ##
                    # @api private
                    #
                    # @!attribute [r] validator
                    #   @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator]
                    #
                    attr_reader :validator

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base]
                    #
                    delegate :matcher, to: :validator

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    delegate :result, to: :matcher

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Chain]
                    #
                    delegate :chain, to: :matcher

                    ##
                    # @api private
                    #
                    # @return [ConvenientService::Service, Symbol]
                    #
                    delegate :step, to: :chain

                    ##
                    # @api private
                    #
                    # @param validator [ConvenientService::RSpec::Matchers::Classes::Results::Base::Entities::Validator]
                    # @return [void]
                    #
                    def initialize(validator:)
                      @validator = validator
                    end

                    ##
                    # @api private
                    #
                    # @return [Boolean]
                    #
                    def call
                      return false unless result

                      Service::Plugins::HasJSendResult::Commands::IsResult[result: result]
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

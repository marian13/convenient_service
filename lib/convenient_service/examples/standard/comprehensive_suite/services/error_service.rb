# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        module Services
          class ErrorService
            include ConvenientService::Standard::Config

            ##
            # @!attribute [r] message
            #   @return [String]
            #
            attr_reader :message

            ##
            # @param message [String]
            # @return [void]
            #
            def initialize(message: "foo")
              @message = message
            end

            ##
            # @return [ConvenientService::Result]
            #
            def result
              error(message)
            end
          end
        end
      end
    end
  end
end

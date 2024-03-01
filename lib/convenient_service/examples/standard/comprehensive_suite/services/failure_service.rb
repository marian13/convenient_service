# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        module Services
          class FailureService
            include ConvenientService::Standard::Config

            ##
            # @!attribute [r] index
            #   @return [Integer]
            #
            attr_reader :index

            ##
            # @param index [Integer]
            # @return [void]
            #
            def initialize(index: -1)
              @index = index
            end

            ##
            # @return [ConvenientService::Result]
            #
            def result
              failure(index: index)
            end
          end
        end
      end
    end
  end
end

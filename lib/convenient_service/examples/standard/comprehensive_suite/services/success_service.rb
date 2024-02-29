# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        module Services
          class SuccessService
            include ConvenientService::Standard::Config

            ##
            # @!attribute [r] data
            #   @return [Hash{Symbol => Object}]
            #
            attr_reader :data

            ##
            # @param data [Hash{Symbol => Object}]
            # @return [void]
            #
            def initialize(data: {foo: :bar})
              @data = data
            end

            ##
            # @return [ConvenientService::Result]
            #
            def result
              success(**data)
            end
          end
        end
      end
    end
  end
end

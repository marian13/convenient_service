# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Commands
          class IsResult < Support::Command
            ##
            # @!attribute [r] result
            #   @return [Object] Can any type.
            #
            attr_reader :result

            ##
            # @param result [Object] Can any type.
            # @return [void]
            #
            def initialize(result:)
              @result = result
            end

            ##
            # @return [void]
            #
            def call
              result.class.include?(Entities::Result::Concern)
            end
          end
        end
      end
    end
  end
end

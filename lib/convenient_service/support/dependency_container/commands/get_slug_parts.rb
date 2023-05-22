# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class GetSlugParts < Support::Command
          ##
          # @!attribute [r] slug
          #   @return [Symbol, String]
          #
          attr_reader :slug

          ##
          # @param slug [Symbol, String]
          # @return [void]
          #
          def initialize(slug:)
            @slug = slug
          end

          ##
          # @return [Array]
          #
          def call
            Utils::String.split(slug, ".", "::").map(&:to_sym)
          end
        end
      end
    end
  end
end

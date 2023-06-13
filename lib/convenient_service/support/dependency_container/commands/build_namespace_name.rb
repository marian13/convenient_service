# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class BuildNamespaceName < Support::Command
          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @param scope [Symbol]
          # @param prepend [Boolean]
          # @return [void]
          #
          def initialize(scope:, prepend:)
            @scope = scope
            @prepend = prepend
          end

          ##
          # @return [Symbol]
          #
          def call
            :"Imported#{imported_prefix}#{scoped_prefix}Methods"
          end

          private

          ##
          # @return [String]
          #
          def imported_prefix
            prepend ? "Prepended" : "Included"
          end

          ##
          # @return [String]
          #
          def scoped_prefix
            case scope
            when Constants::INSTANCE_SCOPE then "Instance"
            when Constants::CLASS_SCOPE then "Class"
            end
          end
        end
      end
    end
  end
end

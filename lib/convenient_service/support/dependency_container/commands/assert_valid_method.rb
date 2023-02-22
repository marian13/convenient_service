# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class AssertValidMethod < Support::Command
          ##
          # @!attribute [r] from
          #   @return [Object]
          #
          attr_reader :method

          ##
          # @!attribute [r] from
          #   @return [Object]
          #
          attr_reader :full_name

          ##
          # @!attribute [r] from
          #   @return [Object]
          #
          attr_reader :scope

          ##
          # @!attribute [r] from
          #   @return [Object]
          #
          attr_reader :from

          ##
          # @param from [Object]
          # @return [void]
          #
          def initialize(method:, full_name:, scope:, from:)
            @method = method
            @full_name = full_name
            @scope = scope
            @from = from
          end

          ##
          # @return [void]
          # @raise [ConvenientService::Support::DependencyContainer::Errors::NotExportedMethod]
          #
          def call
            raise Errors::NotExportedMethod.new(method_name: full_name, method_scope: scope, mod: from) unless method
          end
        end
      end
    end
  end
end

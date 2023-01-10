# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class MethodCollection
          ##
          # @param methods [Array<ConvenientService::Support::DependencyContainer::Entities::Method>]
          # @return [void]
          #
          def initialize(methods: [])
            @methods = methods
          end

          ##
          # @param full_name [String, Symbol]
          # @param scope [:instance, :class]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method, nil]
          #
          def find_by(full_name: Support::NOT_PASSED, scope: Support::NOT_PASSED)
            rules = []

            rules << ->(method) { method.full_name.to_s == full_name.to_s } if full_name != Support::NOT_PASSED
            rules << ->(method) { method.scope == scope } if scope != Support::NOT_PASSED

            condition = Utils::Proc.conjunct(rules)

            methods.find(&condition)
          end

          ##
          # @param method [ConvenientService::Support::DependencyContainer::Entities::Method]
          # @return [ConvenientService::Support::DependencyContainer::Entities::MethodCollection]
          #
          def <<(method)
            methods << method
          end

          ##
          # @param method [ConvenientService::Support::DependencyContainer::Entities::Method]
          # @return [Boolean]
          #
          def include?(method)
            methods.include?(method)
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if methods != other.methods

            true
          end

          protected

          ##
          # @!attribute [r] methods
          #   @return [Array<ConvenientService::Support::DependencyContainer::Entities::Method>]
          #
          attr_reader :methods
        end
      end
    end
  end
end

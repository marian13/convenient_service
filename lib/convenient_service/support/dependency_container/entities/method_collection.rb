# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
          # @param name [String, Symbol]
          # @param slug [String, Symbol]
          # @param scope [:instance, :class]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method, nil]
          #
          def find_by(name: Support::NOT_PASSED, slug: Support::NOT_PASSED, scope: Support::NOT_PASSED)
            rules = []

            rules << ->(method) { method.name.to_s == name.to_s } unless Support::NOT_PASSED[name]
            rules << ->(method) { method.slug.to_s == slug.to_s } unless Support::NOT_PASSED[slug]
            rules << ->(method) { method.scope == scope } unless Support::NOT_PASSED[scope]

            condition = Utils::Proc.conjunct(rules)

            methods.find(&condition)
          end

          ##
          # @param method [ConvenientService::Support::DependencyContainer::Entities::Method]
          # @return [ConvenientService::Support::DependencyContainer::Entities::MethodCollection]
          #
          def <<(method)
            methods << method

            self
          end

          ##
          # @return [Boolean]
          #
          def empty?
            methods.empty?
          end

          ##
          # @param method [ConvenientService::Support::DependencyContainer::Entities::Method]
          # @return [Boolean]
          #
          def include?(method)
            methods.include?(method)
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::MethodCollection]
          #
          def clear
            methods.clear

            self
          end

          ##
          # @return [Array]
          #
          def to_a
            methods.to_a
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean, nil]
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

# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class NamespaceCollection
          ##
          # @param namespaces [Array<ConvenientService::Support::DependencyContainer::Entities::Namespace>]
          # @return [void]
          #
          def initialize(namespaces: [])
            @namespaces = namespaces
          end

          ##
          #
          #
          def define_namespace(namespace)
            namespaces << namespace

            define_singleton_method(namespace.name) { namespace.body.call }
          end

          ##
          # @param name [String, Symbol]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Namespace, nil]
          #
          def find_by(name: Support::NOT_PASSED)
            rules = []

            rules << ->(namespace) { namespace.name.to_s == name.to_s } if name != Support::NOT_PASSED

            condition = Utils::Proc.conjunct(rules)

            namespaces.find(&condition)
          end

          ##
          # @param namespace [ConvenientService::Support::DependencyContainer::Entities::Namespace]
          # @return [ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection]
          #
          def <<(namespace)
            namespaces << namespace

            self
          end

          ##
          # @return [Boolean]
          #
          def empty?
            namespaces.empty?
          end

          ##
          # @param namespace [ConvenientService::Support::DependencyContainer::Entities::Namespace]
          # @return [Boolean]
          #
          def include?(namespace)
            namespaces.include?(namespace)
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection]
          #
          def clear
            namespaces.clear

            self
          end

          ##
          # @return [Array]
          #
          def to_a
            namespaces.to_a
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if namespaces != other.namespaces

            true
          end

          protected

          ##
          # @!attribute [r] namespaces
          #   @return [Array<ConvenientService::Support::DependencyContainer::Entities::Namespace>]
          #
          attr_reader :namespaces
        end
      end
    end
  end
end

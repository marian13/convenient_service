# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class Namespace
          ##
          # @!attribute [r] name
          #   @return [String, Symbol]
          #
          attr_reader :name

          ##
          # @param name [String, Symbol]
          # @return [void]
          #
          def initialize(name:)
            @name = name
          end

          ##
          # @return [Proc]
          #
          def body
            @body ||= -> { namespace }
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::NamespaceCollection]
          #
          def namespaces
            @namespaces ||= Entities::NamespaceCollection.new
          end

          ##
          # @param name [String, Symbol]
          # @param body [Proc]
          # @return [Symbol]
          #
          def define_method(name, &body)
            define_singleton_method(name, &body)
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean, nil]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if name != other.name

            true
          end

          private

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::Namespace]
          #
          def namespace
            self
          end
        end
      end
    end
  end
end

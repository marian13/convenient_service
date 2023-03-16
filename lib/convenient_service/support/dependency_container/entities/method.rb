# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class Method
          ##
          # @!attribute [r] full_name
          #   @return [String, Symbol]
          #
          attr_reader :full_name

          ##
          # @!attribute [r] scope
          #   @return [:instance, :class]
          #
          attr_reader :scope

          ##
          # @!attribute [r] body
          #   @return [Proc]
          #
          attr_reader :body

          ##
          # @param full_name [String, Symbol]
          # @param scope [:instance, :class]
          # @param body [Proc]
          # @return [void]
          #
          def initialize(full_name:, scope:, body:, as: "")
            @full_name = full_name
            @scope = scope
            @body = body
            @as = as
          end

          ##
          # @return [String]
          #
          def name
            @name ||= full_name_parts.last
          end

          ##
          # @return [Array<ConvenientService::Support::DependencyContainer::Entities::Namespace>]
          #
          def namespaces
            @namespaces ||= full_name_parts.slice(0..-2).map { |part| Entities::Namespace.new(name: part) }
          end

          ##
          # @return [String]
          #
          def create_alias(name)
            @as = name
          end

          ##
          # @param mod [Module]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          def define_in_module!(mod)
            ##
            # NOTE: `innermost_namespace` is just `mod`, when `namespaces` are empty.
            #
            innermost_namespace =
              namespaces.reduce(mod) do |namespace, sub_namespace|
                already_defined_sub_namespace = namespace.namespaces.find_by(name: sub_namespace.name)

                ##
                # NOTE:
                #   - Reuses already defined namespace from previous "imports".
                #   - In contrast, same methods are always redefined.
                #
                next already_defined_sub_namespace if already_defined_sub_namespace

                namespace.namespaces << sub_namespace

                namespace.define_method(sub_namespace.name) { sub_namespace.body.call }

                sub_namespace
              end

            ##
            # NOTE:
            #   - Same methods are redefined.
            #   - In contrast, same namespaces are always reused.
            #
            innermost_namespace.define_method(name, &body)

            self
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if full_name != other.full_name
            return false if scope != other.scope
            return false if body != other.body

            true
          end

          private

          ##
          # @return [Array<String>]
          #
          def full_name_parts
            @full_name_parts ||= Utils::String.split(name_to_split, ".", "::").map(&:to_sym)
          end

          ##
          # @return [String]
          #
          def name_to_split
            @name_to_split ||= as.empty? ? full_name : as
          end

          ##
          # @!attribute [r] as
          #   @return [Proc]
          #
          attr_accessor :as
        end
      end
    end
  end
end

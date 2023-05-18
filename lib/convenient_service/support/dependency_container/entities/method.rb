# frozen_string_literal: true
require "byebug"

module ConvenientService
  module Support
    module DependencyContainer
      module Entities
        class Method
          include Support::Copyable

          ##
          # @!attribute [r] slug
          #   @return [String, Symbol]
          #
          attr_reader :slug

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
          # @!attribute [r] alias_slug
          #   @return [String, Symbol]
          #
          attr_reader :alias_slug

          ##
          # @param slug [String, Symbol]
          # @param scope [:instance, :class]
          # @param body [Proc]
          # @param alias_slug [String, Symbol]
          # @return [void]
          #
          def initialize(slug:, scope:, body:, alias_slug: "")
            @slug = slug
            @scope = scope
            @body = body
            @alias_slug = alias_slug
          end

          ##
          # @return [Symbol]
          #
          def name
            @name ||= alias_slug_parts.last || slug_parts.last
          end

          ##
          # @return [Array<ConvenientService::Support::DependencyContainer::Entities::Namespace>]
          #
          def namespaces
            @namespaces ||= (alias_slug_parts.any? ? alias_slug_parts : slug_parts).slice(0..-2).map { |part| Entities::Namespace.new(name: part) }
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

              namespaces_enum(mod)

            ##
            # NOTE:
            #   - Same methods are redefined.
            #   - In contrast, same namespaces are always reused.
            #
            innermost_namespace.define_method(name, &body)

            self
          end

          def namespaces_enum(namespace)
            ::Enumerator.new do |yielder|
              yielder.yield(namespace)

              namespaces.each do |sub_namespace|
                if namespace.namespaces.find_by(name: sub_namespace.name).nil?
                  namespace.namespaces << sub_namespace
                  namespace.define_method(sub_namespace.name) { sub_namespace.body.call }
                end

                namespace = sub_namespace

                yielder.yield(namespace)
              end
            end
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean]
          #
          def ==(other)
            return unless other.instance_of?(self.class)

            return false if slug != other.slug
            return false if scope != other.scope
            return false if body != other.body
            return false if alias_slug != other.alias_slug

            true
          end

          ##
          # @return [Hash]
          #
          def to_kwargs
            {
              slug: slug,
              scope: scope,
              body: body,
              alias_slug: alias_slug
            }
          end

          private

          ##
          # @return [Array<Symbol>]
          #
          def slug_parts
            @slug_parts ||= Utils::String.split(slug, ".", "::").map(&:to_sym)
          end

          ##
          # @return [Array<Symbol>]
          #
          def alias_slug_parts
            @alias_slug_parts ||= Utils::String.split(alias_slug, ".", "::").map(&:to_sym)
          end
        end
      end
    end
  end
end

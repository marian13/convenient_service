# frozen_string_literal: true

module ConvenientService
  module Feature
    module Plugins
      module CanHaveEntries
        module Commands
          class DefineEntry < Support::Command
            ##
            # @!attribute [r] feature_class
            #   @return [Class]
            #
            attr_reader :feature_class

            ##
            # @!attribute [r] name
            #   @return [String, Symbol]
            #
            attr_reader :name

            ##
            # @!attribute [r] body
            #   @return [Proc]
            #
            attr_reader :body

            ##
            # @param feature_class [Class]
            # @param name [String, Symbol]
            # @param body [Proc]
            #
            def initialize(feature_class:, name:, body:)
              @feature_class = feature_class
              @name = name
              @body = body
            end

            ##
            # @return [String, Symbol]
            #
            def call
              ##
              # NOTE: Just `feature_class.define_singleton_method` does NOT create a closure for `name`.
              # That is why `feature_class.class_exec` wrapper is required.
              #
              feature_class.class_exec(name) do |name|
                define_singleton_method(name) { |*args, **kwargs, &block| new.public_send(name, *args, **kwargs, &block) }
              end

              feature_class.define_method(name, &body)

              name
            end
          end
        end
      end
    end
  end
end

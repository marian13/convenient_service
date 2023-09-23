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
              feature_class.define_singleton_method(name, &body)

              name
            end
          end
        end
      end
    end
  end
end

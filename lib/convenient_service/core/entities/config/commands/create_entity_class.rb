# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Commands
          class CreateEntityClass < Support::Command
            include Support::Delegate

            ##
            # @!attribute [r] config
            #   @return [Class]
            #
            attr_reader :config

            ##
            # @!attribute [r] name
            #   @return [Symbol]
            #
            attr_reader :name

            ##
            # @return [Class]
            #
            delegate :klass, to: :config

            ##
            # @param config [Class]
            # @param name [Symbol]
            # @return [void]
            #
            def initialize(config:, name:)
              @config = config
              @name = name
            end

            ##
            # @return [Class]
            #
            def call
              klass.const_set(name, entity_klass)
            end

            private

            ##
            # @return [Class]
            #
            def entity_klass
              @entity_klass ||=
                ::Class.new.tap do |entity_klass|
                  entity_klass.class_exec(klass) do |namespace|
                    include ::ConvenientService::Core

                    ##
                    # @api private
                    #
                    # @return [Class]
                    #
                    define_singleton_method(:namespace) { namespace }
                  end
                end
            end
          end
        end
      end
    end
  end
end

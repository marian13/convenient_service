# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultStatusCheckShortSyntax
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def success?(...)
              result(...).success?
            end

            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def error?(...)
              result(...).error?
            end

            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def failure?(...)
              result(...).failure?
            end

            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def not_success?(...)
              result(...).not_success?
            end

            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def not_error?(...)
              result(...).not_error?
            end

            ##
            # @return [Boolean]
            # @since 0.2.0
            #
            def not_failure?(...)
              result(...).not_failure?
            end

            ##
            # @return [Boolean]
            #
            alias ok? success?

            ##
            # @return [Boolean]
            #
            alias not_ok? not_success?
          end
        end
      end
    end
  end
end

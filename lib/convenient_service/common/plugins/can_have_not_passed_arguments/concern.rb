# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveNotPassedArguments
        module Concern
          include Support::Concern

          class_methods do
            private

            ##
            # @return [ConvenientService::Support::NOT_PASSED]
            #
            def not_passed
              Support::NOT_PASSED
            end

            ##
            # @param argument [Object] Can be any type.
            # @return [Boolean]
            #
            def not_passed?(argument)
              Support::NOT_PASSED[argument]
            end
          end

          instance_methods do
            private

            ##
            # @return [ConvenientService::Support::NOT_PASSED]
            #
            def not_passed
              Support::NOT_PASSED
            end

            ##
            # @param argument [Object] Can be any type.
            # @return [Boolean]
            #
            def not_passed?(argument)
              Support::NOT_PASSED[argument]
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultStatusCheckShortSyntax
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @return [Boolean]
            #
            def success?(...)
              result(...).success?
            end

            ##
            # @return [Boolean]
            #
            def error?(...)
              result(...).error?
            end

            ##
            # @return [Boolean]
            #
            def failure?(...)
              result(...).failure?
            end

            ##
            # @return [Boolean]
            #
            def not_success?(...)
              result(...).not_success?
            end

            ##
            # @return [Boolean]
            #
            def not_error?(...)
              result(...).not_error?
            end

            ##
            # @return [Boolean]
            #
            def not_failure?(...)
              result(...).not_failure?
            end

            ##
            # @return [Boolean]
            #
            def ok?(...)
              result(...).success?
            end

            ##
            # @return [Boolean]
            #
            def not_ok?(...)
              result(...).not_success?
            end
          end
        end
      end
    end
  end
end

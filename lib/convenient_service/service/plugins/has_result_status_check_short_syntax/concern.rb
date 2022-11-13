# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultStatusCheckShortSyntax
        module Concern
          include Support::Concern

          class_methods do
            def success?(...)
              result(...).success?
            end

            def error?(...)
              result(...).error?
            end

            def failure?(...)
              result(...).failure?
            end

            def not_success?(...)
              result(...).not_success?
            end

            def not_error?(...)
              result(...).not_error?
            end

            def not_failure?(...)
              result(...).not_failure?
            end
          end
        end
      end
    end
  end
end

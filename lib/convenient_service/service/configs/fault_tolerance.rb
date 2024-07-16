# frozen_string_literal: true

module ConvenientService
  module Service
    module Configs
      module FaultTolerance
        include Support::Concern

        # rubocop:disable Lint/ConstantDefinitionInBlock
        included do
          include Configs::Essential

          ##
          # TODO: `Service#steps_result`, `Service#regular_result`.
          # TODO: Ensure `RescuesResultUnhandledExceptions` is used as last middleware. Add `proxy`, `decorator` specifiers?
          #
          middlewares :result, scope: :class do
            use ConvenientService::Plugins::Service::RescuesResultUnhandledExceptions::Middleware
          end
        end
        # rubocop:enable Lint/ConstantDefinitionInBlock
      end
    end
  end
end

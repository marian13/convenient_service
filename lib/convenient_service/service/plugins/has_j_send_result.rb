# frozen_string_literal: true

require_relative "has_j_send_result/concern"
require_relative "has_j_send_result/constants"
require_relative "has_j_send_result/container"
require_relative "has_j_send_result/commands"
require_relative "has_j_send_result/entities"
require_relative "has_j_send_result/exceptions"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        class << self
          ##
          # Checks whether an object is a result instance.
          #
          # @api public
          #
          # @param result [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   result = Service.result
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result?(result)
          #   # => true
          #
          #   ConvenientService::Plugins::Service::HasJSendResult.result?(42)
          #   # => false
          #
          def result?(result)
            Commands::IsResult[result: result]
          end
        end
      end
    end
  end
end

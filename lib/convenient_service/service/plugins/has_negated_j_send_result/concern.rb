# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasNegatedJSendResult
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   NOTE: `original_result = result` is used to cache `result` independently, without relying on `CachesReturnValue` plugin.
            #
            #   TODO: `Utils::String.concat_if`? How?
            #   - https://stackoverflow.com/a/28648594/12201472
            #
            def negated_result
              original_result = result

              case result.status.to_sym
              when :success
                failure(
                  data: original_result.unsafe_data,
                  message: "Original `result` is `success`#{" with `message` - #{original_result.unsafe_message}" unless original_result.unsafe_message.empty?}",
                  code: "negated_#{original_result.unsafe_code}"
                )
              when :failure
                success(
                  data: original_result.unsafe_data,
                  message: "Original `result` is `failure`#{" with `message` - #{original_result.unsafe_message}" unless original_result.unsafe_message.empty?}",
                  code: "negated_#{original_result.unsafe_code}"
                )
              when :error
                original_result.copy
              end
            end
          end
        end
      end
    end
  end
end

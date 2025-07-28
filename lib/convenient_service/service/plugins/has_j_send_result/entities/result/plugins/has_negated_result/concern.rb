# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasNegatedResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def negated?
                      Utils.to_bool(extra_kwargs[:negated])
                    end

                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                    #
                    # @internal
                    #   NOTE: `original_result = result` is used to cache `result` independently, without relying on `CachesReturnValue` plugin.
                    #
                    #   TODO: `Utils::String.concat_if`? How?
                    #   - https://stackoverflow.com/a/28648594/12201472
                    #
                    #   IMPORTANT: `copy` is used instead of `service.success`, or `service.failure` in order to reuse the original result extra kwargs, like `step`, `parent`, etc.
                    #
                    #   TODO: A simple way to get constant without referencing other plugin.
                    #
                    def negated_result
                      case status.to_sym
                      when :success
                        copy(
                          overrides: {
                            kwargs: {
                              status: :failure,
                              data: unsafe_data,
                              message: "Original `result` is `success`#{" with `message` - #{unsafe_message}" unless unsafe_message.empty?}",
                              code: "negated_#{unsafe_code}"
                            }
                          }
                        )
                      when :failure
                        copy(
                          overrides: {
                            kwargs: {
                              status: :success,
                              data: unsafe_data,
                              message: "Original `result` is `failure`#{" with `message` - #{unsafe_message}" unless unsafe_message.empty?}",
                              code: "negated_#{unsafe_code}"
                            }
                          }
                        )
                      else # :error
                        copy
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

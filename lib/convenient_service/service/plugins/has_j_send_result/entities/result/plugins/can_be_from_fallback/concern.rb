# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeFromFallback
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def fallback_failure_result?
                      Utils.to_bool(extra_kwargs[:fallback_failure_result])
                    end

                    ##
                    # @return [Boolean]
                    #
                    def fallback_error_result?
                      Utils.to_bool(extra_kwargs[:fallback_error_result])
                    end

                    ##
                    # @return [Boolean]
                    #
                    def fallback_result?
                      fallback_failure_result? || fallback_error_result?
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

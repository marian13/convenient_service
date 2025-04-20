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
                      Utils.to_bool(extra_kwargs[:fallback_result])
                    end

                    ##
                    # @return [Boolean]
                    #
                    def fallback?
                      fallback_failure_result? || fallback_error_result? || fallback_result?
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

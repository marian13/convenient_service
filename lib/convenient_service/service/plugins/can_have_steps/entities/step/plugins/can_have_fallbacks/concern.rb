# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanHaveFallbacks
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Bool]
                    #
                    def fallback_true_step?
                      params.extra_kwargs[:fallback] == true
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_failure_step?
                      Utils::Array.wrap(params.extra_kwargs[:fallback]).include?(:failure)
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_error_step?
                      Utils::Array.wrap(params.extra_kwargs[:fallback]).include?(:error)
                    end

                    ##
                    # @return [Bool]
                    #
                    def fallback_step?
                      fallback_true_step? || fallback_failure_step? || fallback_error_step?
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

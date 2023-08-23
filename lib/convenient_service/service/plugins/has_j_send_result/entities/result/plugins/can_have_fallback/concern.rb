# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanHaveFallback
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def fallback_result?
                      Utils.to_bool(extra_kwargs[:fallback_result])
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

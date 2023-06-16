# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveCheckedStatus
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def has_checked_status?
                      Utils.to_bool(internals.cache[:has_checked_status])
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

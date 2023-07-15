# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeTried
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def try_result?
                      Utils.to_bool(extra_kwargs[:try_result])
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

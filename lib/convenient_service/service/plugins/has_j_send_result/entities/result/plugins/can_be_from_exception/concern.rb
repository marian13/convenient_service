# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeFromException
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @api public
                    #
                    # @return [Boolean]
                    #
                    def from_exception?
                      Utils.to_bool(extra_kwargs[:from_exception])
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

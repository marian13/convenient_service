# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeNegated
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [Boolean]
                    #
                    def negated?
                      Utils.to_bool(extra_kwargs[:negated])
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

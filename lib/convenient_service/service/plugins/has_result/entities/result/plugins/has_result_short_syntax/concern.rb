# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasResultShortSyntax
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # NOTE: `Support::Delegate' is NOT used intentionally in order to NOT pollute the public interface.
                    #
                    def [](key)
                      data[key]
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

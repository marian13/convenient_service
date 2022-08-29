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
                  module InstanceMethods
                    ##
                    # NOTE: `Support::Delegate' is NOT used intentionally in order to NOT pollute the public interface.
                    #
                    # rubocop:disable Rails/Delegate
                    def [](key)
                      data[key]
                    end
                    # rubocop:enable Rails/Delegate
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

# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            module Plugins
              ##
              # @internal
              #   TODO: Consider to refactor into common plugin?
              #
              module HasCache
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Support::Cache]
                    #
                    def cache
                      @cache ||= Support::Cache.new
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

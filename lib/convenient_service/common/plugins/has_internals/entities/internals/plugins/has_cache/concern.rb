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
                    # @return [ConvenientService::Support::Cache::Hash]
                    #
                    def cache
                      Support::Cache.set_default_class(false)

                      @cache ||= Support::Cache.default_class.new
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

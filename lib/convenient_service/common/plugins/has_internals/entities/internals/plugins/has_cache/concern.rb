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

                  class_methods do
                    ##
                    # @return [ConvenientService::Support::Cache]
                    #
                    # @internal
                    #   TODO: `Support::Cache.create(backend: :thread_safe_hash)`.
                    #
                    def cache
                      @cache ||= Support::Cache.create(backend: :hash)
                    end
                  end

                  instance_methods do
                    ##
                    # @return [ConvenientService::Support::Cache]
                    #
                    def cache
                      @cache ||= Support::Cache.create(backend: :hash)
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

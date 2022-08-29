# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            module Plugins
              module HasCache
                ##
                # TODO: Specs.
                #
                module Concern
                  include Support::Concern

                  instance_methods do
                    def cache
                      @cache ||= Entities::Cache.new
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

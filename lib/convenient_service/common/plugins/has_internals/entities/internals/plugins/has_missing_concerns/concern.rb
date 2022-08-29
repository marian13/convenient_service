# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            module Plugins
              module HasMissingConcerns
                module Concern
                  include Support::Concern

                  instance_methods do
                    include Support::Dependency

                    ##
                    # TODO: Matcher.
                    #
                    dependency :cache, from: Internals::Plugins::HasCache::Concern
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

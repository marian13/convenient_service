# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
                    def cache
                      @cache ||= Support::Cache.backed_by(:thread_safe_hash).new
                    end
                  end

                  instance_methods do
                    ##
                    # @return [ConvenientService::Support::Cache]
                    #
                    def cache
                      @cache ||= Support::Cache.backed_by(:hash).new
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

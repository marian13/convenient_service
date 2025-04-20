# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Common
    module Plugins
      module CachesReturnValue
        class Middleware < MethodChainMiddleware
          intended_for any_method, scope: any_scope, entity: any_entity

          ##
          # @return [Object] Can be any type.
          #
          def next(...)
            cache.fetch(key) { chain.next(...) }
          end

          private

          ##
          # @return [ConvenientService::Support::Cache]
          #
          def cache
            @cache ||= entity.internals.cache
          end

          ##
          # @return [ConvenientService::Support::Cache::Entities::Key]
          #
          def key
            @key ||= cache.keygen(:return_values, method, *next_arguments.args, **next_arguments.kwargs, &next_arguments.block)
          end
        end
      end
    end
  end
end

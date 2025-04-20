# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "observable/entities"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module MiddlewareCreators
                class Observable < MiddlewareCreators::Base
                  ##
                  # @return [Hash{Symbol => ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable::Entities::Event}]
                  #
                  def middleware_events
                    @middleware_events ||= ::Hash.new { |hash, key| hash[key] = Entities::Event.new(type: key) }
                  end

                  ##
                  # @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Base]
                  #
                  def decorated_middleware
                    middleware.to_observable_middleware
                  end

                  ##
                  # @return [Hash{Symbol => Hash{Symbol => ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::MiddlewareCreators::Observable::Entities::Event}}]
                  #
                  def extra_kwargs
                    {middleware_events: middleware_events}
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

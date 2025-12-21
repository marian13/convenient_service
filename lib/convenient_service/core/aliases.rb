# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ##
  # Base class for concern middlewares.
  #
  # @api private
  # @since 1.0.0
  # @return [Class]
  #
  ConcernMiddleware = ::ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware

  ##
  # Base class for method middlewares using classic `stack.call`.
  #
  # @api public
  # @since 1.0.0
  # @return [Class]
  #
  # @note Prefer `ConvenientService::MethodChainMiddleware`.
  #
  # @example Common usage.
  #   class Middleware < ConvenientService::MethodClassicMiddleware
  #     def call(env)
  #       p env
  #
  #       value = stack.call(env)
  #
  #       p value
  #
  #       value
  #     end
  #   end
  #
  #   class Service
  #     include ConvenientService::Standard::Config
  #
  #     middlewares :result do
  #       insert_before 0, Middleware
  #     end
  #
  #     def result
  #       success
  #     end
  #   end
  #
  #   Service.result
  #   # {args: [], kwargs: {}, block: nil, entity: <Service>, method: :result}
  #   # <Service::Result status: :success>
  #   # => <Service::Result status: :success>
  #
  MethodClassicMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic

  ##
  # Base class for method middlewares using `chain.next`.
  #
  # @api public
  # @since 1.0.0
  # @return [Class]
  #
  # @example Common usage.
  #   class Middleware < ConvenientService::MethodChainMiddleware
  #     def next(*args, **kwargs, &block)
  #       p [args, kwargs, block]
  #
  #       value = chain.next(*args, **kwargs, &block)
  #
  #       p value
  #
  #       value
  #     end
  #   end
  #
  #   class Service
  #     include ConvenientService::Standard::Config
  #
  #     middlewares :result do
  #       insert_before 0, Middleware
  #     end
  #
  #     def result
  #       success
  #     end
  #   end
  #
  #   Service.result
  #   # {args: [], kwargs: {}, block: nil, entity: <Service>, method: :result}
  #   # <Service::Result status: :success>
  #   # => <Service::Result status: :success>
  #
  MethodChainMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain
end

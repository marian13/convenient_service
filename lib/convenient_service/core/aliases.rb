# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  ConcernMiddleware = ::ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware

  MethodClassicMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic
  MethodChainMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain
end

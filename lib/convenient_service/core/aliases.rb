# frozen_string_literal: true

module ConvenientService
  ConcernMiddleware = ::ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware

  MethodClassicMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Classic
  MethodChainMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middlewares::Chain
end

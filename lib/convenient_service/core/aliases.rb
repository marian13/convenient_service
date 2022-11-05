# frozen_string_literal: true

module ConvenientService
  module Core
    ClassicMiddleware = ::ConvenientService::Core::Entities::ClassicMiddleware
    ConcernMiddleware = ::ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Middleware
    MethodChainMiddleware = ::ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Middleware
  end
end

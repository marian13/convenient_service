# frozen_string_literal: true

module ConvenientService
  module Core
    ClassicMiddleware = ::ConvenientService::Core::Entities::ClassicMiddleware
    ConcernMiddleware = ::ConvenientService::Core::Entities::Concerns::Entities::Middleware
    MethodChainMiddleware = ::ConvenientService::Core::Entities::Middlewares::MethodChainMiddleware
  end
end

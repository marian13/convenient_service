# frozen_string_literal: true

module ConvenientService
  module Core
    ClassicMiddleware = ::ConvenientService::Core::Entities::ClassicMiddleware
    ConcernMiddleware = ::ConvenientService::Core::Entities::Concerns::ConcernMiddleware
    MethodChainMiddleware = ::ConvenientService::Core::Entities::Middlewares::MethodChainMiddleware
  end
end

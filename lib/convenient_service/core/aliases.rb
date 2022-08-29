# frozen_string_literal: true

module ConvenientService
  module Core
    ##
    # Aliases.
    #
    ClassicMiddleware = Entities::ClassicMiddleware
    ConcernMiddleware = Entities::Concerns::ConcernMiddleware
    MethodChainMiddleware = Entities::Middlewares::MethodChainMiddleware
  end
end

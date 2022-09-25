# frozen_string_literal: true

module ConvenientService
  module Plugins
    Common = ::ConvenientService::Common::Plugins

    Internals = ::ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Plugins

    Result = ::ConvenientService::Service::Plugins::HasResult::Entities::Result::Plugins

    Service = ::ConvenientService::Service::Plugins
  end

  module Standard
    Config = ::ConvenientService::Configs::Standard
    CommittedConfig = ::ConvenientService::Configs::StandardCommitted
    UncommittedConfig = ::ConvenientService::Configs::StandardUncommitted
  end
end

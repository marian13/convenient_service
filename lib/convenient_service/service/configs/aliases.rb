# frozen_string_literal: true

module ConvenientService
  module Standard
    Config = ::ConvenientService::Service::Configs::Standard
  end

  module Callbacks
    Config = ::ConvenientService::Service::Configs::Callbacks
  end

  module Fallbacks
    Config = ::ConvenientService::Service::Configs::Fallbacks
  end

  module Inspect
    Config = ::ConvenientService::Service::Configs::Inspect
  end

  module FaultTolerance
    Config = ::ConvenientService::Service::Configs::FaultTolerance
  end
end

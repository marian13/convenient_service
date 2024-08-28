# frozen_string_literal: true

module ConvenientService
  module Standard
    Config = ::ConvenientService::Service::Configs::Standard
  end

  module Callbacks
    Config = ::ConvenientService::Service::Configs::Callbacks
  end

  module Rollbacks
    Config = ::ConvenientService::Service::Configs::Rollbacks
  end

  module Fallbacks
    Config = ::ConvenientService::Service::Configs::Fallbacks
  end

  module FaultTolerance
    Config = ::ConvenientService::Service::Configs::FaultTolerance
  end

  module Inspect
    Config = ::ConvenientService::Service::Configs::Inspect
  end

  module Recalculation
    Config = ::ConvenientService::Service::Configs::Recalculation
  end

  module RSpec
    Config = ::ConvenientService::Service::Configs::RSpec
  end

  module ShortSyntax
    Config = ::ConvenientService::Service::Configs::ShortSyntax
  end
end

# frozen_string_literal: true

require_relative "comprehensive_suite/services"

module ConvenientService
  module Examples
    module Standard
      class ComprehensiveSuite
        include ConvenientService::Feature::Standard::Config
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module IncludeConfig
        def include_config(...)
          RSpec::Matchers::Classes::IncludeConfig.new(...)
        end
      end
    end
  end
end

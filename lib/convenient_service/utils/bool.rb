# frozen_string_literal: true

require_relative "bool/to_bool"

module ConvenientService
  module Utils
    module Bool
      class << self
        def to_bool(...)
          ToBool.call(...)
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "string/camelize"

module ConvenientService
  module Utils
    module String
      class << self
        def camelize(...)
          Camelize.call(...)
        end
      end
    end
  end
end

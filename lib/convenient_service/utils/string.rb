# frozen_string_literal: true

require_relative "string/camelize"
require_relative "string/demodulize"
require_relative "string/split"

module ConvenientService
  module Utils
    module String
      class << self
        def camelize(...)
          Camelize.call(...)
        end

        def demodulize(...)
          Demodulize.call(...)
        end

        def split(...)
          Split.call(...)
        end
      end
    end
  end
end

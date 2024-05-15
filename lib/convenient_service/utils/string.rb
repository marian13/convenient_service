# frozen_string_literal: true

require_relative "string/camelize"
require_relative "string/demodulize"
require_relative "string/enclose"
require_relative "string/split"
require_relative "string/truncate"

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

        def enclose(...)
          Enclose.call(...)
        end

        def split(...)
          Split.call(...)
        end

        def truncate(...)
          Truncate.call(...)
        end
      end
    end
  end
end

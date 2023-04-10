# frozen_string_literal: true

require_relative "array/pair"

module ConvenientService
  module Support
    class Cache
      class Constants
        BACKENDS = [
          :array,
          :hash
        ]
      end
    end
  end
end

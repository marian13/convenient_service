# frozen_string_literal: true

require_relative "hash/except"

module ConvenientService
  module Utils
    module Hash
      class << self
        def except(...)
          Except.call(...)
        end
      end
    end
  end
end

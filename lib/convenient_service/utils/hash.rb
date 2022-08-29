# frozen_string_literal: true

require_relative "hash/except"

module ConvenientService
  module Utils
    module Hash
      class << self
        def except(hash, keys:)
          Except.call(hash, keys: keys)
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "method/defined"
require_relative "method/find_own"

module ConvenientService
  module Utils
    module Method
      class << self
        def defined?(...)
          Defined.call(...)
        end

        def find_own(...)
          FindOwn.call(...)
        end
      end
    end
  end
end

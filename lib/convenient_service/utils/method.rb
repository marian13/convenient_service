# frozen_string_literal: true

require_relative "method/defined"
require_relative "method/name"
require_relative "method/remove"

module ConvenientService
  module Utils
    module Method
      class << self
        def defined?(...)
          Defined.call(...)
        end

        def remove(...)
          Remove.call(...)
        end
      end
    end
  end
end

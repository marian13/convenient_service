# frozen_string_literal: true

require_relative "method/defined"

module ConvenientService
  module Utils
    module Method
      class << self
        def defined?(...)
          Defined.call(...)
        end
      end
    end
  end
end

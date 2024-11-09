# frozen_string_literal: true

require_relative "name/append"

module ConvenientService
  module Utils
    module Method
      module Name
        class << self
          def append(...)
            Append.call(...)
          end
        end
      end
    end
  end
end

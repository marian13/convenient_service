# frozen_string_literal: true

require_relative "timeout/with_timeout"

module ConvenientService
  module Examples
    module Standard
      module V1
        class Factorial
          module Utils
            module Timeout
              class << self
                def with_timeout(...)
                  WithTimeout.call(...)
                end
              end
            end
          end
        end
      end
    end
  end
end

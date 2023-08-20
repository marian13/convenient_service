# frozen_string_literal: true

require_relative "array/wrap"

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Utils
          module Array
            class << self
              def wrap(object)
                Wrap.call(object)
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "object/blank"
require_relative "object/present"

module ConvenientService
  module Examples
    module Standard
      module V1
        class RequestParams
          module Utils
            module Object
              class << self
                def blank?(object)
                  Blank.call(object)
                end

                def present?(object)
                  Present.call(object)
                end
              end
            end
          end
        end
      end
    end
  end
end

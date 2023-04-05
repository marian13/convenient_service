# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Structs
                  JSendAttributes = ::Struct.new(:service, :status, :data, :message, :code, keyword_init: true)
                end
              end
            end
          end
        end
      end
    end
  end
end

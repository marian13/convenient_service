# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Structs
                  JSendAttributes = ::Struct.new(:service, :status, :data, :message, :code, :extra_kwargs, keyword_init: true)
                end
              end
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "status/commands"
require_relative "status/concern"
require_relative "status/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Status
                    include Concern
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

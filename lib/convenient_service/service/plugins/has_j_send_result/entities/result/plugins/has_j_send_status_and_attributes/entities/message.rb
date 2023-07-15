# frozen_string_literal: true

require_relative "message/commands"
require_relative "message/concern"
require_relative "message/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Message
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

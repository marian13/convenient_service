# frozen_string_literal: true

require_relative "data/commands"
require_relative "data/concern"
require_relative "data/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Data
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

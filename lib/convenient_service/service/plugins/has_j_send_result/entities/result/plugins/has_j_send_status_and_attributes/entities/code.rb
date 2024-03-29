# frozen_string_literal: true

require_relative "code/commands"
require_relative "code/concern"
require_relative "code/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Code
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

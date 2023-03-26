# frozen_string_literal: true

require_relative "data/concern"

module ConvenientService
  module Service
    module Plugins
      module HasResult
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

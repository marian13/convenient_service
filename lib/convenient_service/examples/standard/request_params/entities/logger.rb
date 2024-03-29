# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class RequestParams
        module Entities
          class Logger
            class << self
              def log(message, out: $stdout)
                out.puts message

                message
              end
            end
          end
        end
      end
    end
  end
end

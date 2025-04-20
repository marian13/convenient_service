# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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

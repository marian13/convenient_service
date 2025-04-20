# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class Cowsay
          module Services
            class Print
              include ConvenientService::Standard::V1::Config

              attr_reader :text, :out

              step Services::BuildCloud, in: :text, out: :cloud
              step Services::BuildCow, out: :cow
              step :result

              def initialize(text: "Hello World!", out: $stdout)
                @text = text
                @out = out
              end

              def result
                out.puts cloud + cow

                success
              end
            end
          end
        end
      end
    end
  end
end

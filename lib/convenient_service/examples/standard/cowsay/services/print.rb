# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      class Cowsay
        module Services
          class Print
            include ConvenientService::Standard::Config

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

# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class Cowsay
          module Services
            class BuildCloud
              include ConvenientService::Standard::V1::Config

              attr_reader :text

              def initialize(text: "Hello World!")
                @text = text
              end

              def result
                success(cloud: cloud)
              end

              private

              ##
              # Copied with ❤️ from https://github.com/gaborbata/rosetta-cow
              #
              def cloud
                <<~HEREDOC
                   #{border(text, "_")}
                  < #{text} >
                   #{border(text, "-")}
                HEREDOC
              end

              def border(text, char)
                char * (text.length + 2)
              end
            end
          end
        end
      end
    end
  end
end

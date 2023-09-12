# frozen_string_literal: true

module ConvenientService
  module Examples
    module Standard
      module V1
        class Cowsay
          module Services
            class BuildCow
              include ConvenientService::Standard::V1::Config

              def result
                success(cow: cow)
              end

              private

              ##
              # Copied with ❤️ from https://github.com/gaborbata/rosetta-cow
              #
              def cow
                <<~'HEREDOC'.split("\n").map { |line| offset(line) }.join("\n")
                  \   ^__^
                   \  (oo)\_______
                      (__)\       )\/\
                          ||----w |
                          ||     ||
                HEREDOC
              end

              def offset(line)
                " " * 10 + line
              end
            end
          end
        end
      end
    end
  end
end

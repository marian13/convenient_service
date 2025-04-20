# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Standard
      module V1
        class Gemfile
          module Services
            class AssertFileExists
              include ConvenientService::Standard::V1::Config

              attr_reader :path

              def initialize(path:)
                @path = path
              end

              def result
                return failure(path: "Path is `nil`") if path.nil?
                return failure(path: "Path is empty") if path.empty?

                return error("File with path `#{path}` does NOT exist") unless ::File.exist?(path)

                success
              end
            end
          end
        end
      end
    end
  end
end

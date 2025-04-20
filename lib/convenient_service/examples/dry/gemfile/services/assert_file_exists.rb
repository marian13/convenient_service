# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Dry
      class Gemfile
        module Services
          class AssertFileExists
            include DryService::Config

            option :path

            contract do
              schema do
                required(:path).filled(:string)
              end
            end

            def result
              return failure("File with path `#{path}` does NOT exist") unless ::File.exist?(path)

              success
            end
          end
        end
      end
    end
  end
end

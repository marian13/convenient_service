# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Examples
    module Dry
      module V1
        class Gemfile
          module Services
            class AssertFileNotEmpty
              include DryService::Config

              option :path

              contract do
                schema do
                  required(:path).filled(:string)
                end
              end

              def result
                return error(message: "File with path `#{path}` is empty") if ::File.zero?(path)

                success
              end
            end
          end
        end
      end
    end
  end
end

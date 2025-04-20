# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "gemfile/rails_service"
require_relative "gemfile/services"

##
# @internal
#   Usage example:
#
#   result = ConvenientService::Examples::Rails::Gemfile.format("Gemfile")
#   result = ConvenientService::Examples::Rails::Gemfile.format("spec/cli/gemfile/format/fixtures/Gemfile")
#
module ConvenientService
  module Examples
    module Rails
      class Gemfile
        include ConvenientService::Feature::Standard::Config

        entry :format

        def format(path)
          Services::Format[path: path]
        end
      end
    end
  end
end

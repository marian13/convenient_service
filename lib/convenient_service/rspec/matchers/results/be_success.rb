# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Results
        module BeSuccess
          ##
          # @api public
          #
          def be_success(...)
            Classes::Results::BeSuccess.new(...)
          end
        end
      end
    end
  end
end

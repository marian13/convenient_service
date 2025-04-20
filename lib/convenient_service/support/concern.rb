# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module Concern
      def self.included(klass)
        klass.extend Dependencies::Extractions::ActiveSupportConcern::Concern
      end
    end
  end
end

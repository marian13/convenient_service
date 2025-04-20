# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "kernel/silence_warnings"

module ConvenientService
  module Utils
    module Kernel
      class << self
        def silence_warnings(...)
          SilenceWarnings.call(...)
        end
      end
    end
  end
end

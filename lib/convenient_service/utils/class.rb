# frozen_string_literal: true

require_relative "class/display_name"

module ConvenientService
  module Utils
    module Class
      class << self
        ##
        # @api private
        #
        # @return [String]
        #
        def display_name(...)
          DisplayName.call(...)
        end
      end
    end
  end
end

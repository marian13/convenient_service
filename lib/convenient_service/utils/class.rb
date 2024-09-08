# frozen_string_literal: true

require_relative "class/display_name"
require_relative "class/get_attached_object"

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

        ##
        # @api private
        #
        # @return [Class, nil]
        #
        def attached_object(...)
          GetAttachedObject.call(...)
        end
      end
    end
  end
end

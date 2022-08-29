# frozen_string_literal: true

require_relative "internals/concern"
require_relative "internals/plugins"

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Entities
          class Internals
            include Concern
          end
        end
      end
    end
  end
end

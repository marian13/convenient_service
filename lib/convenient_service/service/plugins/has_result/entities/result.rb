# frozen_string_literal: true

require_relative "result/concern"
require_relative "result/plugins"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            include Concern
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "result/commands"
require_relative "result/concern"
require_relative "result/entities"
require_relative "result/errors"
require_relative "result/plugins"
require_relative "result/structs"

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

# frozen_string_literal: true

require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Concern
              include Support::Concern
            end
          end
        end
      end
    end
  end
end

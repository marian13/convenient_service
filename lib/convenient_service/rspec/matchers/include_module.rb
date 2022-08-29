# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module IncludeModule
        def include_module(*args)
          Custom::IncludeModule.new(*args)
        end
      end
    end
  end
end

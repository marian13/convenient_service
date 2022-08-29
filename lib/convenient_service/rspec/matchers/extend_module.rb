# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module ExtendModule
        def extend_module(*args)
          Custom::ExtendModule.new(*args)
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module ExtendModule
        def extend_module(...)
          Custom::ExtendModule.new(...)
        end
      end
    end
  end
end

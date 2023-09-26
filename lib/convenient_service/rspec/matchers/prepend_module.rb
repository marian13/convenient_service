# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module PrependModule
        def prepend_module(...)
          Classes::PrependModule.new(...)
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module PrependModule
        def prepend_module(*args)
          Custom::PrependModule.new(*args)
        end
      end
    end
  end
end

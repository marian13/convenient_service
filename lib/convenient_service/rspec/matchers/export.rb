# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Export
        def export(...)
          Classes::Export.new(...)
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module InThreads
        def in_threads(...)
          Classes::InThreads.call(...)
        end
      end
    end
  end
end

# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module InThreads
        def in_threads(...)
          Custom::InThreads.call(...)
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "proc/conjunct"

module ConvenientService
  module Utils
    module Proc
      class << self
        ##
        # TODO: Specs.
        #
        def conjunct(procs)
          Conjunct.call(procs)
        end
      end
    end
  end
end

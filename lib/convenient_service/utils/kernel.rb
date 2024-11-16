# frozen_string_literal: true

require_relative "kernel/silence_warnings"

module ConvenientService
  module Utils
    module Kernel
      class << self
        def silence_warnings(...)
          SilenceWarnings.call(...)
        end
      end
    end
  end
end

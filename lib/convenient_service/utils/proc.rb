# frozen_string_literal: true

require_relative "proc/conjunct"
require_relative "proc/display"
require_relative "proc/exec_config"

module ConvenientService
  module Utils
    module Proc
      class << self
        def conjunct(...)
          Conjunct.call(...)
        end

        def display(...)
          Display.call(...)
        end

        def exec_config(...)
          ExecConfig.call(...)
        end
      end
    end
  end
end

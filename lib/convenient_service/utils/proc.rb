# frozen_string_literal: true

require_relative "proc/conjunct"
require_relative "proc/exec_config"

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

        ##
        # @param proc [Proc]
        # @param object [Object]
        # @return [Object] Block return value. Can be any type.
        #
        def exec_config(proc, object)
          ExecConfig.call(proc, object)
        end
      end
    end
  end
end

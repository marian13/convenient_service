# frozen_string_literal: true

module ConvenientService
  module Utils
    module Proc
      ##
      # @return [Object] Can be any type.
      #
      # @internal
      #   TODO: Specs.
      #
      class ExecConfig < Support::Command
        ##
        # @!attribute [r] object
        #   @return [Object] Can be any type.
        #
        attr_reader :object

        ##
        # @!attribute [r] proc
        #   @return [Proc]
        #
        attr_reader :proc

        ##
        # @param proc [Proc]
        # @param objcet [Object] Can be any type.
        # @return [void]
        #
        def initialize(proc, object)
          @proc = proc
          @object = object
        end

        ##
        # @return [Object] Can be any type.
        #
        # @internal
        #   TODO: Stronger check whether `proc` receives exactly one mandatory positional argument.
        #
        def call
          proc.arity == 1 ? proc.call(object) : object.instance_exec(&proc)
        end
      end
    end
  end
end

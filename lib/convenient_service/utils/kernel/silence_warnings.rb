# frozen_string_literal: true

##
# @example
#   ConvenientService::Utils::Kernel::SilenceWarnings.call { String = String }
#
module ConvenientService
  module Utils
    module Kernel
      class SilenceWarnings < Support::Command
        ##
        # @!attribute [r] block
        #   @return [Proc]
        #
        attr_reader :block

        ##
        # @param block [Proc]
        # @return [void]
        #
        def initialize(&block)
          @block = block
        end

        ##
        # @return [Hash]
        #
        # @internal
        #   NOTE: Copied with minimal modifications from:
        #   - https://api.rubyonrails.org/classes/Kernel.html#method-i-silence_warnings
        #   - https://api.rubyonrails.org/classes/Kernel.html#method-i-with_warnings
        #
        #  NOTE: When `$VERBOSE` is set to `false`, Ruby still emits warnings (at least in RSpec).
        #  - https://stackoverflow.com/a/18979544/12201472
        #
        def call
          old_verbose, $VERBOSE = $VERBOSE, nil

          block.call
        ensure
          $VERBOSE = old_verbose
        end
      end
    end
  end
end

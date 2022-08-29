# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        ##
        # TODO: Specs.
        #
        class IgnoringError < Support::Command
          attr_reader :errors, :block

          def initialize(*errors, &block)
            @errors = errors
            @block = block
          end

          def call
            block.call
          rescue *errors
            nil
          else
            raise
          end
        end
      end
    end
  end
end

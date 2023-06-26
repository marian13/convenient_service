# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # @abstract Subclass and override {#initialize} and {#call} to implement a `Command`.
    #
    class Command
      module Errors
        class CallIsNotOverridden < ::ConvenientService::Error
          def initialize(command:)
            message = <<~TEXT
              Call method (#call) of `#{command.class}` is NOT overridden.
            TEXT

            super(message)
          end
        end
      end

      class << self
        ##
        # @return [Object] Can be any type.
        #
        def call(...)
          new(...).call
        end

        ##
        # @return [Object] Can be any type.
        #
        # @internal
        #   NOTE: Delegates to `call` instead of aliasing in order to have an ability
        #   to use the same RSpec stubs for short and usual syntax.
        #
        #   For example:
        #
        #     allow(Command).to receive(:call).with(:foo).and_call_original
        #
        #   works for both `Command.call(:foo)` and `Command[:foo]`.
        #
        def [](...)
          call(...)
        end
      end

      ##
      # @abstract
      # @return [void]
      #
      def initialize(...)
      end

      ##
      # @abstract
      # @return [Object] Can be any type.
      # @raise [ConvenientService::Support::Command::Errors::CallIsNotOverridden]
      #
      def call
        raise Errors::CallIsNotOverridden.new(command: self)
      end
    end
  end
end

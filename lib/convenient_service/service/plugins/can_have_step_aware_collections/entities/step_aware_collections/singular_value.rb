# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class SingularValue < Entities::StepAwareCollections::Base
              ##
              # @api private
              #
              # @!attribute [r] result
              #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              attr_reader :result

              ##
              # @api private
              #
              # @param organizer [ConvenientService::Service]
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(organizer:, result: nil)
                @organizer = organizer
                @result = result
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def all?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def any?(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chain(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chunk(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def chunk_while(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def collect(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def collect_concat(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def count(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def cycle(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def detect(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def drop(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def drop_while(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              # ...

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def first(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end
            end
          end
        end
      end
    end
  end
end

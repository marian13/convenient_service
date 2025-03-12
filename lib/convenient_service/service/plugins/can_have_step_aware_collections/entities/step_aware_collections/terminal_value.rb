# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class TerminalValue < Entities::StepAwareCollections::Base
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
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              # @return [void]
              #
              def initialize(organizer:, result:)
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

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_cons(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_entry(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_slice(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_with_index(...)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::AlreadyUsedTerminalChaining]
              #
              def each_with_object(...)
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

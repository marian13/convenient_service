# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Failure
          module Commands
            class AssertKwargsContainOnlyJSendKeys < Support::Command
              ##
              # @!attribute [r] kwargs
              #   @return [Hash{Symbol => Object}]
              #
              attr_reader :kwargs

              ##
              # @param kwargs [Hash{Symbol => Object}]
              # @return [void]
              #
              def initialize(kwargs:)
                @kwargs = kwargs
              end

              ##
              # @return [void]
              # @raise [ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Failure::Errors::KwargsContainNonJSendKey]
              #
              def call
                raise Errors::KwargsContainNonJSendKey.new(key: non_jsend_keys.first) if non_jsend_keys.any?
              end

              private

              ##
              # @return [Array<Symbol>]
              #
              def non_jsend_keys
                kwargs.keys - valid_jsend_keys
              end

              ##
              # @return [Array<Symbol>]
              #
              def valid_jsend_keys
                [:data, :message]
              end
            end
          end
        end
      end
    end
  end
end

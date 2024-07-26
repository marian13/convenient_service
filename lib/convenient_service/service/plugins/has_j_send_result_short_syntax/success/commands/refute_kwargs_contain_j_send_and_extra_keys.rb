# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Success
          module Commands
            class RefuteKwargsContainJSendAndExtraKeys < Support::Command
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
              # @raise [ConvenientService::Service::Plugins::HasJSendResultShortSyntax::Success::Exceptions::KwargsContainJSendAndExtraKeys]
              #
              # @example `kwargs.keys.difference([:data, :message, :code]).none?`.
              #
              #   {}.keys.difference([:data, :message, :code]).none?
              #   # => true
              #
              #   {a: 1}.keys.difference([:data, :message, :code]).none?
              #   # => false
              #
              #   {data: {}}.keys.difference([:data, :message, :code]).none?
              #   # => true
              #
              #   {data: {}, a: 1}.keys.difference([:data, :message, :code]).none?
              #   # => false
              #
              #   {data: {}, message: ""}.keys.difference([:data, :message, :code]).none?
              #   # => true
              #
              #   {data: {}, message: "", a: 1}.keys.difference([:data, :message, :code]).none?
              #   # => false
              #
              #   {data: {}, message: "", code: :""}.keys.difference([:data, :message, :code]).none?
              #   # => true
              #
              #   {data: {}, message: "", code: :"", a: 1}.keys.difference([:data, :message, :code]).none?
              #   # => false
              #
              def call
                return if [:data, :message, :code].none? { |key| kwargs.has_key?(key) }

                return if kwargs.keys.difference([:data, :message, :code]).none?

                ::ConvenientService.raise Exceptions::KwargsContainJSendAndExtraKeys.new
              end
            end
          end
        end
      end
    end
  end
end

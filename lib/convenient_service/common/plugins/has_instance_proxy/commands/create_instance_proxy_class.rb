# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Commands
          class CreateInstanceProxyClass < Support::Command
            ##
            # @!attribute [r] namespace
            #   @return [Class]
            #
            attr_reader :namespace

            ##
            # @param namespace [Class]
            # @return [void]
            #
            # @internal
            #   TODO: Direct Specs.
            #
            def initialize(namespace:)
              @namespace = namespace
            end

            ##
            # @return [void]
            #
            # @internal
            #   TODO: Direct Specs.
            #
            def call
              klass = ::Class.new(Entities::InstanceProxy)

              ##
              # @example Result for feature.
              #
              #   klass = ConvenientService::Common::Plugins::HasInstanceProxy::Commands::CreateInstanceProxyClass.call(
              #     namespace: SomeFeature
              #   )
              #
              #   ##
              #   # `klass` is something like:
              #   #
              #   # class InstanceProxy < ConvenientService::Service::Plugins::HasInstanceProxy::Entities::InstanceProxy
              #   #   class << self
              #   #     def namespace
              #   #       ##
              #   #       # NOTE: Returns `namespace` passed to `CreateInstanceProxyClass`.
              #   #       #
              #   #       namespace
              #   #     end
              #   #
              #   #     def ==(other)
              #   #       return unless other.respond_to?(:namespace)
              #   #
              #   #       self.namespace == other.namespace
              #   #     end
              #   #   end
              #   # end
              #
              klass.class_exec(namespace) do |namespace|
                define_singleton_method(:namespace) { namespace }

                ##
                # @internal
                #   TODO: Try `self.namespace == other.namespace if self < ::ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy`.
                #
                define_singleton_method(:==) { |other| self.namespace == other.namespace if other.respond_to?(:namespace) }

                ##
                # TODO: `inspect`.
                #
                # define_singleton_method(:inspect) { "#{namespace}InstanceProxy" }
              end

              klass
            end
          end
        end
      end
    end
  end
end

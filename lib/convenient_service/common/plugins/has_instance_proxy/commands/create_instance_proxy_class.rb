# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInstanceProxy
        module Commands
          class CreateInstanceProxyClass < Support::Command
            ##
            # @!attribute [r] target_class
            #   @return [Class]
            #
            attr_reader :target_class

            ##
            # @param target_class [Class]
            # @return [void]
            #
            def initialize(target_class:)
              @target_class = target_class
            end

            ##
            # @return [void]
            #
            def call
              klass = ::Class.new(Entities::InstanceProxy)

              ##
              # @example Result for feature.
              #
              #   klass = ConvenientService::Common::Plugins::HasInstanceProxy::Commands::CreateInstanceProxyClass.call(
              #     target_class: SomeFeature
              #   )
              #
              #   ##
              #   # `klass` is something like:
              #   #
              #   # class InstanceProxy < ConvenientService::Service::Plugins::HasInstanceProxy::Entities::InstanceProxy
              #   #   class << self
              #   #     def target_class
              #   #       ##
              #   #       # NOTE: Returns `target_class` passed to `CreateInstanceProxyClass`.
              #   #       #
              #   #       target_class
              #   #     end
              #   #
              #   #     def ==(other)
              #   #       return unless other.respond_to?(:target_class)
              #   #
              #   #       self.target_class == other.target_class
              #   #     end
              #   #   end
              #   # end
              #
              klass.class_exec(target_class) do |target_class|
                define_singleton_method(:target_class) { target_class }

                ##
                # @internal
                #   TODO: Try `self.target_class == other.target_class if self < ::ConvenientService::Common::Plugins::HasInstanceProxy::Entities::InstanceProxy`.
                #
                define_singleton_method(:==) { |other| self.target_class == other.target_class if other.respond_to?(:target_class) }

                ##
                # TODO: `inspect`.
                #
                # define_singleton_method(:inspect) { "#{target_class}InstanceProxy" }
              end

              klass
            end
          end
        end
      end
    end
  end
end

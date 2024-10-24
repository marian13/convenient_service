# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveUserProvidedEntity
        module Commands
          class FindOrCreateEntity < Support::Command
            ##
            # @!attribute [r] namespace
            #   @return [Class]
            #
            attr_reader :namespace

            ##
            # @!attribute [r] proto_entity
            #   @return [Class]
            #
            attr_reader :proto_entity

            ##
            # @param namespace [Class]
            # @param proto_entity [Class]
            # @return [void]
            #
            def initialize(namespace:, proto_entity:)
              @namespace = namespace
              @proto_entity = proto_entity
            end

            ##
            # @return [void]
            #
            def call
              ::ConvenientService.raise Exceptions::ProtoEntityHasNoName.new(proto_entity: proto_entity) unless proto_entity_name
              ::ConvenientService.raise Exceptions::ProtoEntityHasNoConcern.new(proto_entity: proto_entity) unless proto_entity_concern

              entity.include Core

              entity.include proto_entity_concern

              ##
              # @example Result for service.
              #
              #   klass = ConvenientService::Common::Plugins::CanHaveUserProvidedEntity::Commands::FindOrCreateEntity.call(
              #     namespace: SomeService,
              #     proto_entity: ConvenientService::Service::Plugins::HasJSendResult::Entities::Result
              #   )
              #
              #   ##
              #   # `klass` is something like:
              #   #
              #   # class Result < ConvenientService::Service::Plugins::HasJSendResult::Entities::Result # or just `class Result` if service (namespace) class defines its own.
              #   #   include ConvenientService::Service::Plugins::HasJSendResult::Entities::Result::Concern # (concern)
              #   #
              #   #   class << self
              #   #     def proto_entity
              #   #       ##
              #   #       # NOTE: Returns `proto_entity` passed to `FindOrCreateEntity`.
              #   #       #
              #   #       proto_entity
              #   #     end
              #   #
              #   #     def ==(other)
              #   #       return unless other.respond_to?(:proto_entity)
              #   #
              #   #       self.proto_entity == other.proto_entity
              #   #     end
              #   #   end
              #   # end
              #
              entity.class_exec(proto_entity) do |proto_entity|
                ##
                # @return [Class]
                #
                define_singleton_method(:proto_entity) { proto_entity }

                ##
                # @param other [Object] Can by any type.
                # @return [Boolean, nil]
                #
                # @internal
                #   TODO: Try `self.proto_entity == other.proto_entity if self < proto_entity_concern`.
                #
                define_singleton_method(:==) { |other| self.proto_entity == other.proto_entity if other.respond_to?(:proto_entity) }

                ##
                # TODO: `inspect`.
                #
                # define_singleton_method(:inspect) { "#{entity}(Prototyped by #{proto_entity})" }
              end

              entity
            end

            private

            ##
            # @return [Class]
            #
            def entity
              @entity ||= Utils::Module.get_own_const(namespace, proto_entity_demodulized_name) || ::Class.new(proto_entity)
            end

            ##
            # @return [String, nil]
            #
            def proto_entity_name
              Utils.memoize_including_falsy_values(self, :@proto_entity_name) { proto_entity.name }
            end

            ##
            # @return [String]
            #
            def proto_entity_demodulized_name
              @proto_entity_demodulized_name ||= Utils::String.demodulize(proto_entity_name)
            end

            ##
            # @return [Module]
            #
            def proto_entity_concern
              Utils.memoize_including_falsy_values(self, :@proto_entity_concern) { Utils::Module.get_own_const(proto_entity, :Concern) }
            end
          end
        end
      end
    end
  end
end

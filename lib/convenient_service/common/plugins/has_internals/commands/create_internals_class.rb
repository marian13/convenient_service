# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasInternals
        module Commands
          class CreateInternalsClass < Support::Command
            attr_reader :service_class

            def initialize(service_class:)
              @service_class = service_class
            end

            def call
              internals_class.include Entities::Internals::Concern

              ##
              # class Internals < ConvenientService::Common::Plugins::HasInternals::Entities::Internals # or just `class Internals` if service class defines its own.
              #   include ConvenientService::Common::Plugins::HasInternals::Entities::Internals::Concern
              #
              #   class << self
              #     def service_class
              #       ##
              #       # NOTE: Returns `service_class` passed to `CreateInternalsClass`.
              #       #
              #       service_class
              #     end
              #
              #     def ==(other)
              #       return unless other.instance_of?(self.class)
              #
              #       self.service_class == other.service_class
              #     end
              #   end
              # end
              #
              internals_class.class_exec(service_class) do |service_class|
                define_singleton_method(:service_class) { service_class }
                define_singleton_method(:==) { |other| self.service_class == other.service_class if other.instance_of?(self.class) }
              end

              internals_class
            end

            private

            def internals_class
              @internals_class ||= Utils::Object.find_own_const(service_class, :Internals) || ::Class.new(Entities::Internals)
            end
          end
        end
      end
    end
  end
end

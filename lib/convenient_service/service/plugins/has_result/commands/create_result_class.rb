# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Commands
          class CreateResultClass < Support::Command
            attr_reader :service_class

            ##
            # @param service_class [Class]
            # @return [void]
            #
            def initialize(service_class:)
              @service_class = service_class
            end

            ##
            # @return [void]
            #
            def call
              result_class.include Entities::Result::Concern

              ##
              # class Result < ConvenientService::Service::Plugins::HasResult::Entities::Result # or just `class Result` if service class defines its own.
              #   include ConvenientService::Service::Plugins::HasResult::Entities::Result::Concern
              #
              #   class << self
              #     def service_class
              #       ##
              #       # NOTE: Returns `service_class` passed to `CreateResultClass`.
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
              result_class.class_exec(service_class) do |service_class|
                define_singleton_method(:service_class) { service_class }
                define_singleton_method(:==) { |other| self.service_class == other.service_class if other.instance_of?(self.class) }
              end

              result_class
            end

            private

            ##
            # @return [Class]
            #
            def result_class
              @result_class ||= Utils::Module.get_own_const(service_class, :Result) || ::Class.new(Entities::Result)
            end
          end
        end
      end
    end
  end
end

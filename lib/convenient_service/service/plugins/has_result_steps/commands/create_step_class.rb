# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Commands
          class CreateStepClass < Support::Command
            attr_reader :service_class

            def initialize(service_class:)
              @service_class = service_class
            end

            def call
              step_class.include Entities::Step::Concern

              ##
              # class Step < ConvenientService::Service::Plugins::HasResultSteps::Entities::Step # or just `class Step' if service class defines its own.
              #   include ConvenientService::Service::Plugins::HasResultSteps::Entities::Step::Concern
              #
              #   class << self
              #     def service_class
              #       ##
              #       # NOTE: Returns `service_class' passed to `CreateResultClass'.
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
              step_class.class_exec(service_class) do |service_class|
                define_singleton_method(:service_class) { service_class }

                ##
                # TODO: Fix a bug with `ap'.
                #
                define_singleton_method(:==) { |other| self.service_class == other.service_class if other.instance_of?(self.class) }
              end

              step_class
            end

            private

            def step_class
              @step_class ||= Utils::Object.find_own_const(service_class, :Step) || ::Class.new(Entities::Step)
            end
          end
        end
      end
    end
  end
end

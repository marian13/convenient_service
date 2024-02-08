# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              class DefineMethodInContainer < Support::Command
                include Support::Delegate

                attr_reader :method, :container, :index

                delegate :key, :name, to: :method

                def initialize(method:, container:, index:)
                  @method = method
                  @container = container
                  @index = index
                end

                def call
                  ##
                  # NOTE: Assignement in the beginning for easier debugging.
                  #
                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    def #{name}
                      step, key, method_name = steps[#{index}], :#{key}, :#{name}

                      ::ConvenientService.raise #{not_completed_step_error}.new(step: step, method_name: method_name) unless step.completed?

                      ::ConvenientService.raise #{not_existing_step_result_data_attribute_error}.new(step: step, key: key) unless step.result.unsafe_data.has_attribute?(key)

                      step.result.unsafe_data[key]
                    end
                  RUBY

                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    def #{name}
                      method_name = :#{name}

                      ::ConvenientService.raise #{not_existing_step_result_data_attribute_error}.new(step: step, key: method_name) unless internals.cache.scope(:step_output_values).exist?(method_name)

                      internals.cache.scope(:step_output_values).read(method_name)
                    end
                  RUBY

                  true
                end

                private

                def not_completed_step_error
                  <<~RUBY.chomp
                    ::ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotCompletedStep
                  RUBY
                end

                def not_existing_step_result_data_attribute_error
                  <<~RUBY.chomp
                    ::ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::NotExistingStepResultDataAttribute
                  RUBY
                end
              end
            end
          end
        end
      end
    end
  end
end

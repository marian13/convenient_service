# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
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

                      raise #{not_completed_step_error}.new(step: step, method_name: method_name) unless step.completed?

                      raise #{not_existing_step_result_data_attribute_error}.new(step: step, key: key) unless step.result.data.has_key?(key)

                      step.result.data[key]
                    end
                  RUBY

                  true
                end

                private

                def not_completed_step_error
                  <<~RUBY.chomp
                    ::ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::NotCompletedStep
                  RUBY
                end

                def not_existing_step_result_data_attribute_error
                  <<~RUBY.chomp
                    ::ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::NotExistingStepResultDataAttribute
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

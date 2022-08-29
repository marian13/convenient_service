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
                      step, key, name, error = steps[#{index}], :#{key}, :#{name}, #{error}

                      return step.result.data[key] if step.completed?

                      raise ::#{error}.new(step: step, method_name: name)
                    end
                  RUBY

                  true
                end

                private

                def error
                  @error ||=
                    <<~RUBY.chomp
                      ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Errors::NotCompletedStep
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

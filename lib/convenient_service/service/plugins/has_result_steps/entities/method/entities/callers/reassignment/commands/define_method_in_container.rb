# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Entities
              module Callers
                class Reassignment < Callers::Base
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
                        return if Utils::Module.instance_method_defined?(container.klass, "__original_#{name}__", private: true)

                        <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                          alias_method :__original_#{name}__, :#{name}

                          def #{name}
                            step =
                              steps.slice(0..#{index})
                                .select(&:completed?)
                                .reverse
                                .find { |step| step.outputs.any? { |output| output.reassignment?(:#{name}) } }

                            step ? step.result.data[:#{name}] : __send__(:__original_#{name}__)
                          end
                        RUBY

                        true
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

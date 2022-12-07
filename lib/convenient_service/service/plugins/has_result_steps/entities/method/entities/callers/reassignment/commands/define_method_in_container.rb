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

                      ##
                      # @return [Boolean]
                      #
                      def call
                        ##
                        # NOTE: `prepend` is thread-safe.
                        #
                        container.klass.prepend reassigned_methods

                        return false if Utils::Module.instance_method_defined?(reassigned_methods, method, private: true)

                        <<~RUBY.tap { |code| reassigned_methods.module_eval(code, __FILE__, __LINE__ + 1) }
                          def #{name}
                            steps
                              .select { |step| step.has_reassignment?(__method__) }
                              .select(&:completed?)
                              .last
                              .then { |step| step ? step.result.data[__method__] : super }
                          end
                        RUBY

                        true
                      end

                      private

                      ##
                      # @return [Module]
                      #
                      def reassigned_methods
                        @reassigned_methods ||= Utils::Module.fetch_own_const(container.klass, :ReassignedMethods) { ::Module.new }
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

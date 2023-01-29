# frozen_string_literal: true

require_relative "export/entities"

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class Export
          attr_reader :method_name, :scope

          def initialize(method_name, scope: :instance)
            @method_name = method_name
            @scope = scope
          end

          def matches?(container)
            method = container.exported_methods.find_by(full_name: method_name, scope: scope)

            return false unless method

            return check_expected_value(container: container, method: method_name, scope: scope) if @expected_value

            true
          end

          def description
            "export `#{method_name}` with `#{scope}` scope"
          end

          def failure_message
            "Failure message"
          end

          def and_return(expected_value)
            @expected_value = expected_value

            self
          end

          private

          def check_expected_value(container:, method:, scope: :instance)
            klass = Class.new do
              include ConvenientService::DependencyContainer::Import

              @method_obj = import method, scope: scope, from: container

              def self.matches_value?(expected_value)
                @method_obj.body.call == expected_value
              end
            end

            klass.matches_value?(@expected_value)
          end
        end
      end
    end
  end
end

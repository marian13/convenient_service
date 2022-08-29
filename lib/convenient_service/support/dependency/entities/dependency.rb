# frozen_string_literal: true

module ConvenientService
  module Support
    module Dependency
      module Entities
        class Dependency
          attr_reader :method, :receiver

          def initialize(method, from:)
            @method = method
            @receiver = from

            ##
            # TODO: Specs.
            #
            raise Errors::InstanceReceiver.new(receiver: @receiver) if Utils::Object.resolve_type(@receiver) == "instance"
          end

          def ==(other)
            return unless other.instance_of?(self.class)

            return false if method != other.method
            return false if receiver != other.receiver

            true
          end
        end
      end
    end
  end
end

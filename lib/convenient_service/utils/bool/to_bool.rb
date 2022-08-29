# frozen_string_literal: true

module ConvenientService
  module Utils
    module Bool
      class ToBool < Support::Command
        attr_reader :object

        def initialize(object)
          @object = object
        end

        def call
          !!object
        end
      end
    end
  end
end

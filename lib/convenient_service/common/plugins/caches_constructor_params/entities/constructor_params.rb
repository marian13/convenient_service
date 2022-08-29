# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CachesConstructorParams
        module Entities
          class ConstructorParams
            attr_reader :args, :kwargs, :block

            ##
            # TODO: Specs for default values.
            #
            def initialize(args: [], kwargs: {}, block: nil)
              @args = args
              @kwargs = kwargs
              @block = block
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              return false if args != other.args
              return false if kwargs != other.kwargs
              return false if block&.source_location != other.block&.source_location

              true
            end
          end
        end
      end
    end
  end
end

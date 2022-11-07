# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanAdjustForeignResult
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api public
            # @param klass [Class]
            # @param args [Array]
            # @param kwargs [Hash]
            # @param block [Proc]
            # @return []
            #
            def result_of(klass, *args, **kwargs, &block)
              klass.result(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end

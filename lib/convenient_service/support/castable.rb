# frozen_string_literal: true

require_relative "castable/errors"

module ConvenientService
  module Support
    ##
    # TODO: Specs for options.
    #
    module Castable
      include Support::Concern

      instance_methods do
        private

        def cast(other, **options)
          self.class.cast(other, **options)
        end

        def cast!(other, **options)
          self.class.cast!(other, **options)
        end
      end

      class_methods do
        include Support::AbstractMethod

        abstract_method :cast

        def cast!(other, **options)
          casted = cast(other, **options)

          raise Errors::FailedToCast.new(other: other, klass: self) unless casted

          casted
        end
      end
    end
  end
end

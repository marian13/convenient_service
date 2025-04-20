# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "castable/exceptions"

module ConvenientService
  module Support
    ##
    # TODO: Specs for options.
    #
    module Castable
      include Support::Concern

      instance_methods do
        private

        def cast(...)
          self.class.cast(...)
        end

        def cast!(...)
          self.class.cast!(...)
        end
      end

      class_methods do
        ##
        # @internal
        #   TODO: `include Support::Castable` also extends `Support::AbstractMethod`. Is there a way to avoid such behavior?
        #
        include Support::AbstractMethod

        abstract_method :cast

        def cast!(other, **options)
          casted = cast(other, **options)

          ::ConvenientService.raise Exceptions::FailedToCast.new(other: other, klass: self) unless casted

          casted
        end
      end
    end
  end
end

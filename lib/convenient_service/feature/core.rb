# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Core
      include Support::Concern

      included do
        include ::ConvenientService::Core
      end

      instance_methods do
        ##
        # Returns string representation of feature.
        #
        # @api public
        # @since 1.0.0
        #
        # @param format [Symbol]
        # @return [String]
        #
        # @note Intended to be used for debugging purposes.
        #
        # @example Common usage.
        #   class Feature
        #     include ConvenientFeature::Feature::Standard::Config
        #
        #     entry :main
        #
        #     def main
        #       :main_entry_value
        #     end
        #   end
        #
        #   puts Feature.new
        #   # <Feature>
        #   # => nil
        #
        #   Feature.new.to_s
        #   # => "<Feature>"
        #
        #   Feature.new.to_s(format: :inspect)
        #   # => "<Feature>"
        #
        #   Feature.new.to_s(format: :original)
        #   # => "#<Feature:0x00005639cd363000>"
        #
        def to_s(format: :inspect)
          (format == :inspect) ? inspect : super()
        end
      end
    end
  end
end

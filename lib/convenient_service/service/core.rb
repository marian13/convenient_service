# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Core
      include Support::Concern

      included do
        include ::ConvenientService::Core
      end

      instance_methods do
        ##
        # Returns string representation of service.
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
        #   class Service
        #     include ConvenientService::Standard::Config
        #
        #     def result
        #       success
        #     end
        #   end
        #
        #   puts Service.new
        #   # <Service>
        #   # => nil
        #
        #   Service.new.to_s
        #   # => "<Service>"
        #
        #   Service.new.to_s(format: :inspect)
        #   # => "<Service>"
        #
        #   Service.new.to_s(format: :original)
        #   # => "#<Service:0x00005639cd363000>"
        #
        def to_s(format: :inspect)
          (format == :inspect) ? inspect : super()
        end
      end
    end
  end
end

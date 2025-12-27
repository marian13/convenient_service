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
        # @param format [Symbol]
        # @return [String]
        #
        def to_s(format: :inspect)
          (format == :inspect) ? inspect : super()
        end
      end
    end
  end
end

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

##
# @example Usual class.
#   ConvenientService::Utils::Class::DisplayName.call(String)
#   # => "String"
#
# @example Anonymous class.
#   ConvenientService::Utils::Class::DisplayName.call(Сlass.new)
#   # => "AnonymousClass(#76940)"
#
module ConvenientService
  module Utils
    module Class
      class DisplayName < Support::Command
        ##
        # @api private
        #
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :klass

        ##
        # @api private
        #
        # @param klass [Class]
        # @return [void]
        #
        def initialize(klass)
          @klass = klass
        end

        ##
        # @api private
        #
        # @return [String]
        #
        # @internal
        #   TODO: `Module#name` returns `nil` for anonymous classes.
        #   - https://ruby-doc.org/core-2.7.0/Module.html#method-i-name
        #
        def call
          klass.name || "AnonymousClass(##{klass.object_id})"
        end
      end
    end
  end
end

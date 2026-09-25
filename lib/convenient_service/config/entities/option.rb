# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Entities
      class Option
        ##
        # @!attribute [r] name
        #   @return [Symbol]
        #
        attr_reader :name

        ##
        # @!attribute [r] details
        #   @return [Hash{Symbol => Object}]
        #
        attr_reader :details

        ##
        # @return [Hash{Symbol => Object}]
        #
        alias_method :data, :details

        ##
        # @param name [Symbol]
        # @param enabled [Object] Can be any type.
        # @param details [Hash{Symbol => Object}]
        # @return [void]
        #
        def initialize(name:, enabled: false, **details)
          @name = name
          @enabled = Utils.to_bool(enabled)
          @details = details
        end

        ##
        # @return [Boolean]
        #
        def enabled?
          enabled
        end

        ##
        # @param other [Object] Can be any type.
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if name != other.name
          return false if enabled != other.enabled
          return false if details != other.details

          true
        end

        protected

        ##
        # @!attribute [r] enabled
        #   @return [Boolean]
        #
        attr_reader :enabled
      end
    end
  end
end

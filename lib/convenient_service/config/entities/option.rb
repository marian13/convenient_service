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
        # @!attribute [r] data
        #   @return [Hash{Symbol => Object}]
        #
        attr_reader :data

        ##
        # @param name [Symbol]
        # @param enabled [Object] Can be any type.
        # @param data [Hash{Symbol => Object}]
        # @return [void]
        #
        def initialize(name:, enabled:, **data)
          @name = name
          @enabled = Utils.to_env_bool(enabled)
          @data = data
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
        # @internal
        #   TODO: Tests.
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if name != other.name
          return false if enabled != other.enabled
          return false if data != other.data

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

# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Entities
      ##
      # @internal
      #   TODO: Specs.
      #
      class OptionCollection
        ##
        # @!attribute [r] options
        #   @return [Hash{Symbol => ConvenientService::Config::Entities::Option}]
        #
        attr_reader :options

        ##
        # @param options [Hash{Symbol => ConvenientService::Config::Entities::Option}] Can be any type.
        # @return [void]
        #
        def initialize(options: {})
          @options = options
        end

        ##
        # @return [Array<Symbol>]
        #
        def keys
          options.keys
        end

        ##
        # @return [Boolean]
        #
        def any?
          options.any? { |_name, option| option.enabled? }
        end

        ##
        # @param name [Symbol]
        # @return [Boolean]
        #
        def include?(name)
          return false unless options.has_key?(name)

          options[name].enabled?
        end

        ##
        # @param name [Symbol]
        # @return [Boolean]
        #
        def [](name)
          options[name]
        end

        ##
        # @return [ConvenientService::Config::Entities::OptionCollection]
        #
        def dup
          self.class.new(options: options.dup)
        end

        ##
        # @param other_options [Object] Can be any type.
        # @return [ConvenientService::Config::Entities::OptionCollection]
        #
        def merge(other_options)
          options.merge!(Commands::NormalizeOptions[options: other_options].to_h)

          self
        end

        ##
        # @param other_options [Object] Can be any type.
        # @return [ConvenientService::Config::Entities::OptionCollection]
        #
        def subtract(other_options)
          Commands::NormalizeOptions[options: other_options].to_h.each_key { |name| options.delete(name) }

          self
        end

        ##
        # @param other_options [Object] Can be any type.
        # @return [ConvenientService::Config::Entities::OptionCollection]
        #
        def replace(other_options)
          options.replace(Commands::NormalizeOptions[options: other_options].to_h)

          self
        end

        ##
        # @param other [Object] Can be any type.
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if options != other.options

          true
        end

        ##
        # @return [Array<ConvenientService::Config::Entities::Option>]
        #
        def to_a
          options.values
        end

        ##
        # @return [Hash{Symbol => ConvenientService::Config::Entities::Option}]
        #
        def to_h
          options
        end
      end
    end
  end
end

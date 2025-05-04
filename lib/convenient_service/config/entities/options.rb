# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Entities
      class Options
        ##
        # @!attribute [r] options
        #   @return [Hash]
        #
        attr_reader :options

        ##
        # @param options [Object] Can be any type.
        # @return [void]
        #
        def initialize(options: nil)
          @options = Commands::NormalizeOptions[options: options]
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
        # @return [ConvenientService::Config::Entities::Options]
        #
        def dup
          self.class.new(options: options.dup)
        end

        ##
        # @return [ConvenientService::Config::Entities::Options]
        #
        def merge(other_options)
          options.merge!(Commands::NormalizeOptions[options: other_options])

          self
        end

        ##
        # @return [ConvenientService::Config::Entities::Options]
        #
        def subtract(other_options)
          Commands::NormalizeOptions[options: other_options].each_key { |name| options.delete(name) }

          self
        end

        ##
        # @return [ConvenientService::Config::Entities::Options]
        #
        def replace(other_options)
          options.replace(Commands::NormalizeOptions[options: other_options])

          self
        end

        ##
        # @return [Array]
        #
        def to_a
          options.values
        end
      end
    end
  end
end

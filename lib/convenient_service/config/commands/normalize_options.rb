# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Config
    module Commands
      class NormalizeOptions < Support::Command
        ##
        # @!attribute [r] options
        #   @return [Object] Can be any type.
        #
        attr_reader :options

        ##
        # @param options [Object] Can be any type.
        # @return [void]
        #
        def initialize(options:)
          @options = options
        end

        ##
        # @return [Hash]
        #
        def call
          Utils::Array.wrap(options.to_a)
            .flat_map { |option| normalize(option) }
            .reduce({}) { |memo, option| memo.merge(option.name => option) } # index_by
        end

        ##
        # @param value [Object] Can be any type.
        # @return [ConvenientService::Config::Entities::Option, Array<ConvenientService::Config::Entities::Option>]
        #
        def normalize(value)
          case value
          when ::Symbol then normalize_symbol(value)
          when ::Array then normalize_array(value)
          when ::Set then normalize_set(value)
          when ::Hash then normalize_hash(value)
          when Entities::Option then normalize_option(value)
          when Entities::Options then normalize_options(value)
          else
            raise_option_can_not_be_normalized(value)
          end
        end

        ##
        # @param symbol [Symbol]
        # @return [ConvenientService::Config::Entities::Option]
        #
        def normalize_symbol(symbol)
          Entities::Option.new(name: symbol, enabled: true)
        end

        ##
        # @param array [Array<Object>]
        # @return [Array<ConvenientService::Config::Entities::Option>]
        #
        def normalize_array(array)
          array.map do |value|
            case value
            when ::Symbol then normalize_symbol(value)
            when ::Hash then normalize_hash(value)
            when Entities::Option then normalize_option(value)
            when Entities::Options then normalize_options(value)
            else
              raise_option_can_not_be_normalized(array)
            end
          end
        end

        ##
        # @param set [Set<Object>]
        # @return [Array<ConvenientService::Config::Entities::Option>]
        #
        def normalize_set(set)
          set.map do |value|
            case value
            when ::Symbol then normalize_symbol(value)
            when ::Hash then normalize_hash(value)
            when Entities::Option then normalize_option(value)
            when Entities::Options then normalize_options(value)
            else
              raise_option_can_not_be_normalized(set)
            end
          end
        end

        ##
        # @param hash [Hash{Symbol => Object}]
        # @return [ConvenientService::Config::Entities::Option, Array<ConvenientService::Config::Entities::Option>]
        #
        def normalize_hash(hash)
          return Entities::Option.new(**hash) if hash.has_key?(:name)

          hash.map { |name, enabled| Entities::Option.new(name: name, enabled: enabled) }
        end

        ##
        # @param option [ConvenientService::Config::Entities::Option]
        # @return [ConvenientService::Config::Entities::Option]
        #
        def normalize_option(option)
          option
        end

        ##
        # @param options [ConvenientService::Config::Entities::Options]
        # @return [Array<ConvenientService::Config::Entities::Option>]
        #
        def normalize_options(options)
          options.to_a
        end

        ##
        # @param option [ConvenientService::Config::Entities::Option]
        # @raise [ConvenientService::Config::Exceptions::OptionCanNotBeNormalized]
        #
        def raise_option_can_not_be_normalized(option)
          ::ConvenientService.raise Exceptions::OptionCanNotBeNormalized.new(option: option)
        end
      end
    end
  end
end

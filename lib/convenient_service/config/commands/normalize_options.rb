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
          normalize_options(options)
        end

        ##
        # @param options [Object] Can be any type.
        # @return [Hash]
        #
        def normalize_options(options)
          Utils::Array.wrap(options)
            .flat_map { |option| normalize_option(option) }
            .group_by(&:name)
            .transform_values(&:first)
        end

        ##
        # @param option [Object] Can be any type.
        # @return [Entities::Option]
        #
        def normalize_option(option)
          case option
          when ::Symbol then Entities::Option.new(name: option, enabled: true)
          when ::Hash then normalize_hash(option)
          when Entities::Option then option
          when Entities::Options then option.to_a
          else
            ::ConvenientService.raise Exceptions::OptionCanNotBeNormalized.new(option: option)
          end
        end

        ##
        # @param hash [Hash{Symbol => Object}]
        # @return [Entities::Option]
        #
        def normalize_hash(hash)
          return Entities::Option.new(**hash) if hash.has_key?(:name)

          hash.map { |name, enabled| Entities::Option.new(name: name, enabled: enabled) }
        end
      end
    end
  end
end

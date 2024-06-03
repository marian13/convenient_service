# frozen_string_literal: true

require_relative "version/null_version"

module ConvenientService
  module Dependencies
    module Queries
      class Version
        include ::Comparable

        undef_method :between?

        undef_method :clamp

        ##
        # @param value [String]
        # @return [void]
        #
        def initialize(value)
          @value = value
        end

        class << self
          ##
          # @return [ConvenientService::Dependencies::Queries::Version::NullVersion]
          #
          def null_version
            @null_version ||= Version::NullVersion.new
          end
        end

        ##
        # @return [Boolean]
        #
        def null_version?
          false
        end

        ##
        # @return [Gem::Version, nil]
        #
        def gem_version
          cast_gem_version(value)
        end

        ##
        # @return [String]
        #
        # @internal
        #   TODO: Add direct specs.
        #
        def major_minor
          to_s[/\d+\.\d+/]
        end

        ##
        # @param other [Object] Can be any type.
        # @return [Boolean, nil]
        #
        def <=>(other)
          gem_version <=> cast_gem_version(other)
        end

        ##
        # @return [String]
        #
        def to_s
          gem_version.to_s
        end

        private

        ##
        # @return [String]
        #
        attr_reader :value

        ##
        # @return [Gem::Version, nil]
        #
        def cast_gem_version(value)
          ::Gem::Version.create(value.to_s) if ::Gem::Version.correct?(value.to_s)
        end
      end
    end
  end
end

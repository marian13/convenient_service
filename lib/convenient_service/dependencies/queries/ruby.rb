# frozen_string_literal: true

module ConvenientService
  module Dependencies
    module Queries
      ##
      # @api private
      #
      class Ruby
        class << self
          ##
          # @return [ConvenientService::Dependencies::Queries::Version]
          #
          # @internal
          #   NOTE: Ruby defines `RUBY_VERSION` global variable.
          #   - https://ruby-doc.org/core-2.7.2/doc/globals_rdoc.html
          #
          def version
            @version ||= Version.new(::RUBY_VERSION)
          end

          ##
          # @return [String]
          #
          def engine
            ::RUBY_ENGINE.to_s
          end

          ##
          # @return [ConvenientService::Dependencies::Queries::Version]
          #
          # @internal
          #   NOTE: Ruby defines `RUBY_ENGINE_VERSION` global variable.
          #   - https://ruby-doc.org/core-2.7.2/doc/globals_rdoc.html
          #
          #   NOTE: JRuby defines `RUBY_ENGINE_VERSION` global variable.
          #   - https://github.com/jruby/jruby/blob/9.4.0.0/spec/jruby/compat_spec.rb#L6
          #
          #   NOTE: TruffleRuby defines `RUBY_ENGINE_VERSION` global variable.
          #   - https://github.com/oracle/truffleruby/blob/vm-22.3.0/spec/truffle/identity_spec.rb#L23
          #
          def engine_version
            @version ||= Version.new(::RUBY_ENGINE_VERSION)
          end

          ##
          # Returns `true` when MRI, `false` otherwise.
          #
          # @return [Boolean]
          #
          # @see https://github.com/janlelis/ruby_engine
          #
          # @internal
          #   NOTE: Gratefully copied from the `ruby_engine` gem. Version `1.1.4`.
          #   - https://github.com/janlelis/ruby_engine/blob/v2.0.0/lib/ruby_engine.rb#L19
          #
          def mri?
            ::RUBY_ENGINE.to_s == "ruby"
          end

          alias_method :ruby?, :mri?

          ##
          # Returns `true` when JRuby, `false` otherwise.
          #
          # @return [Boolean]
          #
          # @see https://github.com/rdp/os
          #
          # @internal
          #   NOTE: Gratefully copied from the `os` gem. Version `1.1.4`.
          #   - https://github.com/rdp/os/blob/v1.1.4/lib/os.rb#L101
          #
          #   NOTE: Modified original implementation in order to return a boolean.
          #   NOTE: Consider to use `RUBY_ENGINE` as for others?
          #
          def jruby?
            ::RUBY_PLATFORM.to_s.match?(/java/)
          end

          ##
          # Returns `true` when TruffleRuby, `false` otherwise.
          #
          # @return [Boolean]
          #
          # @internal
          #   NOTE: Taken from irb testing. May NOT be stable.
          #
          #   TODO: Find a confirmation of stability.
          #
          def truffleruby?
            ::RUBY_ENGINE.to_s.match?(/truffleruby/)
          end
        end
      end
    end
  end
end

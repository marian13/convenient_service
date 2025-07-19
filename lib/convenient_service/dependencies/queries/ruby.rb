# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
          # @internal
          #   TODO: Add direct specs.
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
          #   TODO: Add direct specs.
          #
          def engine_version
            @engine_version ||= Version.new(::RUBY_ENGINE_VERSION)
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
          def jruby?
            ::RUBY_ENGINE.to_s.match?(/jruby/)
          end

          ##
          # Returns `true` when TruffleRuby, `false` otherwise.
          #
          # @return [Boolean]
          #
          def truffleruby?
            ::RUBY_ENGINE.to_s.match?(/truffleruby/)
          end

          ##
          # Returns `true` when TruffleRuby, `false` otherwise.
          #
          # @param pattern [String]
          # @return [Boolean]
          #
          def match?(pattern)
            engine_name, operator, engine_version = pattern.split(" ")

            return false unless public_send("#{engine_name}?")
            return false unless self.engine_version.public_send(operator, engine_version)

            true
          end
        end
      end
    end
  end
end

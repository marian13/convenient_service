# frozen_string_literal: true

module ConvenientService
  module Support
    ##
    # @api private
    #
    class Ruby
      class << self
        ##
        # @return [ConvenientService::Support::Version]
        #
        # @internal
        #   https://ruby-doc.org/core-2.7.2/doc/globals_rdoc.html
        #
        def version
          @version ||= Support::Version.new(::RUBY_VERSION)
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

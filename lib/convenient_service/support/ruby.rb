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
        #
        def jruby?
          RUBY_PLATFORM.to_s.match?(/java/)
        end
      end
    end
  end
end

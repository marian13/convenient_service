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
      end
    end
  end
end

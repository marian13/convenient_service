# frozen_string_literal: true

module ConvenientService
  module Support
    class Ruby
      class << self
        ##
        # @return [ConvenientService::Support::Version]
        #
        def version
          @version ||= Support::Version.new(::RUBY_VERSION)
        end
      end
    end
  end
end

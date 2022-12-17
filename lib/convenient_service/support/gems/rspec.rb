# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      class RSpec
        class << self
          ##
          # @return [Boolean]
          #
          def loaded?
            (defined? ::RSpec) ? true : false
          end

          ##
          # @return [ConvenientService::Support::Version]
          #
          def version
            loaded? ? Support::Version.new(::RSpec::Core::Version::STRING) : Support::Version.null_version
          end
        end
      end
    end
  end
end

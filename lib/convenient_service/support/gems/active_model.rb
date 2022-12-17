# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      class ActiveModel
        class << self
          ##
          # @return [Boolean]
          #
          def loaded?
            (defined? ::ActiveModel) ? true : false
          end

          ##
          # @return [ConvenientService::Support::Version]
          #
          def version
            loaded? ? Support::Version.new(::ActiveModel.version) : Support::Version.null_version
          end
        end
      end
    end
  end
end

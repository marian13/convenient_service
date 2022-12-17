# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      ##
      # @api private
      #
      class ActiveModel
        class << self
          ##
          # @return [Boolean]
          #
          # @internal
          #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
          #
          # rubocop:disable Style/TernaryParentheses
          def loaded?
            (defined? ::ActiveModel) ? true : false
          end
          # rubocop:enable Style/TernaryParentheses

          ##
          # @return [ConvenientService::Support::Version]
          #
          # @internal
          #   https://github.com/rails/rails/blob/main/activemodel/lib/active_model/version.rb
          #
          def version
            loaded? ? Support::Version.new(::ActiveModel.version) : Support::Version.null_version
          end
        end
      end
    end
  end
end

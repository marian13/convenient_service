# frozen_string_literal: true

module ConvenientService
  module Support
    module Gems
      ##
      # @api private
      #
      class RSpec
        class << self
          ##
          # @return [Boolean]
          #
          # @internal
          #   `Style/TernaryParentheses` is disabled since `defined?` has too low priority without parentheses.
          #
          # rubocop:disable Style/TernaryParentheses
          def loaded?
            (defined? ::RSpec) ? true : false
          end
          # rubocop:enable Style/TernaryParentheses

          ##
          # @return [ConvenientService::Support::Version]
          #
          # @internal
          #   https://github.com/rspec/rspec-core/blob/main/lib/rspec/core/version.rb
          #
          def version
            loaded? ? Support::Version.new(::RSpec::Core::Version::STRING) : Support::Version.null_version
          end

          ##
          # @return [RSpec::Core::Example, nil]
          #
          # @internal
          #   NOTE: Returns `nil` in environments where RSpec is NOT fully loaded, e.g: irb, rails console, etc.
          #
          #   `::RSpec.current_example` docs:
          #   - https://www.rubydoc.info/github/rspec/rspec-core/RSpec.current_example
          #   - https://github.com/rspec/rspec-core/blob/v3.12.0/lib/rspec/core.rb#L122
          #   - https://relishapp.com/rspec/rspec-core/docs/metadata/current-example
          #
          def current_example
            return unless loaded?

            ##
            # NOTE: This happens in Ruby-only projects where RSpec is loaded by `Bundler.require`, not by `bundle exec rspec`.
            #
            return unless ::RSpec.respond_to?(:current_example)

            ::RSpec.current_example
          end
        end
      end
    end
  end
end

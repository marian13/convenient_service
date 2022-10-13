# frozen_string_literal: true

require_relative "dependencies/built_in"
require_relative "dependencies/extractions"

module ConvenientService
  module Dependencies
    class << self
      ##
      # @return [Boolean]
      #
      def require_assigns_attributes_in_constructor_using_active_model_attribute_assignment
        require "active_model"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
      end

      ##
      # @return [Boolean]
      #
      def require_assigns_attributes_in_constructor_using_dry_initializer
        require "dry-initializer"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_dry_initializer"
      end

      ##
      # @return [Boolean]
      #
      def require_has_attributes_using_active_model_attributes
        require "active_model"

        require_relative "common/plugins/has_attributes/using_active_model_attributes"
      end

      ##
      # @return [Boolean]
      #
      def require_has_result_params_validations_using_active_model_validations
        require "active_model"

        require_relative "service/plugins/has_result_params_validations/using_active_model_validations"
      end

      ##
      # @return [Boolean]
      #
      def require_has_result_params_validations_using_dry_validation
        require "dry-validation"

        require_relative "service/plugins/has_result_params_validations/using_dry_validation"
      end

      ##
      # @return [Boolean]
      #
      def require_development_tools
        require "awesome_print"
        require "byebug"
        require "paint"
        require "rouge"
        require "tempfile"

        require_relative "dependencies/extractions/byebug_syntax_highlighting"
      end

      ##
      # Loads RSpec extensions like `be_success` matcher, `stub_service` helper, etc.
      #
      # @return [Boolean]
      #
      # @note Expected to be called from `spec_helper.rb`.
      #
      def require_rspec_extentions
        require "rspec/expectations"
        require "rspec/matchers"
        require "rspec/mocks"

        require "method_source"
        require "tempfile"

        require_relative "rspec"
      end

      ##
      # Loads standard config examples.
      #
      # @return [Boolean]
      #
      def require_standard_examples
        require "progressbar"

        require_relative "examples/standard/gemfile"
      end

      ##
      # Loads rails config examples.
      #
      # @return [Boolean]
      #
      def require_rails_examples
        require "progressbar"

        require_relative "examples/rails/gemfile"
      end

      ##
      # Loads dry config examples.
      #
      # @return [Boolean]
      #
      def require_dry_examples
        require "progressbar"

        require_relative "examples/dry/gemfile"
      end
    end
  end
end

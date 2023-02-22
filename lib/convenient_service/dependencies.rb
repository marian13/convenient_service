# frozen_string_literal: true

require_relative "dependencies/built_in"
require_relative "dependencies/extractions"

##
# `ConvenientService::Dependencies` can dynamically require plugins/extensions that have external dependencies.
#
# @internal
#   https://github.com/marian13/convenient_service/wiki/Docs:-Dependencies
#
module ConvenientService
  module Dependencies
    class << self
      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_assigns_attributes_in_constructor_using_active_model_attribute_assignment
        require "active_model"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_assigns_attributes_in_constructor_using_dry_initializer
        require "dry-initializer"

        require_relative "common/plugins/assigns_attributes_in_constructor/using_dry_initializer"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_has_attributes_using_active_model_attributes
        require "active_model"

        require_relative "common/plugins/has_attributes/using_active_model_attributes"
      end

      ##
      # @return [Boolean]
      # @api private
      #
      def support_has_result_params_validations_using_active_model_validations?
        return false unless active_model.loaded?
        return false if ruby.version >= 3.0 && active_model.version < 6.0

        true
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      # @see https://marian13.github.io/convenient_service_docs/troubleshooting/i18n_translate_wrong_number_of_arguments
      #
      def require_has_result_params_validations_using_active_model_validations
        require "active_model"

        require_relative "service/plugins/has_result_params_validations/using_active_model_validations"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_has_result_params_validations_using_dry_validation
        require "dry-validation"

        require_relative "service/plugins/has_result_params_validations/using_dry_validation"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from app entry points like `initializers` in Rails.
      #
      def require_rescues_result_unhandled_exceptions
        require_relative "service/plugins/rescues_result_unhandled_exceptions"
      end

      ##
      # @return [Boolean]
      # @note Expected to be called from `irb`, `pry`, `spec_helper.rb`, etc.
      #
      def require_development_tools
        require "awesome_print"
        require "byebug"
        require "paint"
        require "rouge"
        require "tempfile"

        require_relative "dependencies/extractions/byebug_syntax_highlighting"
        require_relative "dependencies/extractions/b"
      end

      ##
      # Loads RSpec extensions like `be_success` matcher, `stub_service` helper, etc.
      #
      # @return [Boolean]
      # @note Expected to be called from `spec_helper.rb`.
      #
      def require_rspec_extentions
        require "rspec/expectations"
        require "rspec/matchers"
        require "rspec/mocks"

        require "tempfile"

        require_relative "rspec"
      end

      ##
      # Loads test factory.
      #
      # @return [Boolean]
      # @note Expected to be called from `spec_helper.rb`.
      #
      def require_factory
        require "faker"

        require_relative "factory"
      end

      ##
      # Loads standard config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_standard_examples
        require "json"
        require "progressbar"
        require "webrick"

        require_relative "examples/standard/cowsay"
        require_relative "examples/standard/request_params"
        require_relative "examples/standard/gemfile"
      end

      ##
      # Loads rails config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_rails_examples
        require "json"
        require "progressbar"
        require "webrick"

        require_relative "examples/rails/gemfile"
      end

      ##
      # Loads dry config examples.
      #
      # @return [Boolean]
      # @api private
      #
      def require_dry_examples
        require "json"
        require "progressbar"
        require "webrick"

        require_relative "examples/dry/gemfile"
      end

      ##
      # @return [ConvenientService::Support::Ruby]
      # @api private
      #
      def ruby
        Support::Ruby
      end

      ##
      # @return [ConvenientService::Support::RSpec]
      # @api private
      #
      def rspec
        Support::Gems::RSpec
      end

      ##
      # @return [ConvenientService::Support::Gems::ActiveModel]
      # @api private
      #
      def active_model
        Support::Gems::ActiveModel
      end
    end
  end
end

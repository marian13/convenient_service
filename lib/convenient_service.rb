# frozen_string_literal: true

require "forwardable"
require "delegate"
require "logger"
require "ostruct"
require "singleton"
require "tempfile"

require_relative "convenient_service/logger"
require_relative "convenient_service/error"
require_relative "convenient_service/extractions"
require_relative "convenient_service/support"
require_relative "convenient_service/utils"
require_relative "convenient_service/version"

require_relative "convenient_service/core"
require_relative "convenient_service/common"
require_relative "convenient_service/service"
require_relative "convenient_service/aliases"
require_relative "convenient_service/configs"

module ConvenientService
  class << self
    ##
    #
    #
    def require_assigns_attributes_in_constructor_using_active_model_attribute_assignment
      require "active_model"

      require_relative "convenient_service/configs/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
      require_relative "convenient_service/common/plugins/assigns_attributes_in_constructor/using_active_model_attribute_assignment"
    end

    ##
    #
    #
    def require_assigns_attributes_in_constructor_using_dry_initializer
      require "dry-initializer"

      require_relative "convenient_service/configs/assigns_attributes_in_constructor/using_dry_initializer"
      require_relative "convenient_service/common/plugins/assigns_attributes_in_constructor/using_dry_initializer"
    end

    ##
    #
    #
    def require_has_attributes_using_active_model_attributes
      require "active_model"

      require_relative "convenient_service/configs/has_attributes/using_active_model_attributes"
      require_relative "convenient_service/common/plugins/has_attributes/using_active_model_attributes"
    end

    ##
    #
    #
    def require_has_result_params_validations_using_active_model_validations
      require "active_model"

      require_relative "convenient_service/configs/has_result_params_validations/using_active_model_validations"
      require_relative "convenient_service/service/plugins/has_result_params_validations/using_active_model_validations"
    end

    ##
    #
    #
    def require_has_result_params_validations_using_dry_validation
      require "dry-validation"

      require_relative "convenient_service/configs/has_result_params_validations/using_dry_validation"
      require_relative "convenient_service/service/plugins/has_result_params_validations/using_dry_validation"
    end

    ##
    #
    #
    def require_development_tools
      require "awesome_print"
      require "byebug"
      require "paint"
    end

    ##
    # Loads RSpec extensions like `be_success' matcher, `stub_service' helper, etc.
    #
    # NOTE: Expected to be called from `spec_helper.rb'.
    #
    def require_rspec_extentions
      require "method_source"

      require_relative "convenient_service/rspec"
    end

    ##
    # Loads examples.
    #
    def require_standard_examples
      require "progressbar"

      require_relative "convenient_service/examples/standard/gemfile"
    end
  end
end

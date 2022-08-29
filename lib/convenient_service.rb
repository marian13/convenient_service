# frozen_string_literal: true

require "forwardable"
require "delegate"
require "ostruct"
require "singleton"

##
# TODO: Optional require.
#
require "active_model"
require "active_record"
require "dry-initializer"
require "dry-validation"

require "byebug"
require "paint"

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
    def require_examples
      require "progressbar"

      require_relative "convenient_service/examples"
    end
  end
end

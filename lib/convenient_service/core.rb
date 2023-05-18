# frozen_string_literal: true

require_relative "core/concern"

require_relative "core/constants"
require_relative "core/entities"

require_relative "core/aliases"

module ConvenientService
  module Core
    include Support::Concern

    included do |entity_class|
      entity_class.include Concern
    end
  end
end

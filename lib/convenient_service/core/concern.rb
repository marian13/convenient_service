# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"

module ConvenientService
  module Core
    module Concern
      include Support::Concern

      included do |entity_class|
        ##
        # NOTE: Currently this aliasing is tested indirectly by `HasConstructor`.
        #
        # TODO: Direct test when `have_alias_method` starts to support classes.
        #
        entity_class.singleton_class.alias_method :new_without_commit_config, :new

        entity_class.include InstanceMethods

        entity_class.extend ClassMethods
      end
    end
  end
end

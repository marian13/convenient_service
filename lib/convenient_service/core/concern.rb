# frozen_string_literal: true

require_relative "concern/instance_methods"
require_relative "concern/class_methods"
require_relative "concern/singleton_class_methods"

module ConvenientService
  module Core
    module Concern
      include Support::Concern

      included do
        ##
        # NOTE: Currently this aliasing is tested indirectly by `HasConstructor`.
        # TODO: Direct test when `have_alias_method` starts to support classes.
        #
        singleton_class.alias_method :new_without_commit_config, :new
      end
    end
  end
end

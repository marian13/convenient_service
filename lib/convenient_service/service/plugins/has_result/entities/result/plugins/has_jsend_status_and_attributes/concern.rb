# frozen_string_literal: true

require_relative "concern/class_methods"
require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                module Concern
                  include Support::Concern

                  included do |result_class|
                    result_class.include InstanceMethods

                    result_class.extend ClassMethods
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

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
                module Entities
                  class Code
                    module Concern
                      include Support::Concern

                      included do |code_class|
                        code_class.include Support::Castable

                        code_class.include InstanceMethods

                        code_class.extend ClassMethods
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
  end
end

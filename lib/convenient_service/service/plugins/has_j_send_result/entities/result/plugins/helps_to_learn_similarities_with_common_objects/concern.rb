# frozen_string_literal: true

require_relative "concern/instance_methods"

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HelpsToLearnSimilaritiesWithCommonObjects
                module Concern
                  include Support::Concern

                  included do |result_class|
                    result_class.include InstanceMethods
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

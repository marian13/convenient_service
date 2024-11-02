# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module CanBeRecalculated
                module Concern
                  include Support::Concern

                  instance_methods do
                    def recalculate
                      service.recalculate_result
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

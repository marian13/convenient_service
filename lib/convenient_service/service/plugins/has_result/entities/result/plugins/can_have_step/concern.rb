# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveStep
                module Concern
                  include Support::Concern

                  instance_methods do
                    def step
                      @step ||= internals.cache[:step]
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

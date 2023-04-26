# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module MarksResultStatusAsChecked
                class Middleware < MethodChainMiddleware
                  intended_for :success?
                  intended_for :failure?
                  intended_for :error?
                  intended_for :not_success?
                  intended_for :not_failure?
                  intended_for :not_error?

                  def next(...)
                    entity.internals.cache[:has_checked_status] = true

                    chain.next(...)
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

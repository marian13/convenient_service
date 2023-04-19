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

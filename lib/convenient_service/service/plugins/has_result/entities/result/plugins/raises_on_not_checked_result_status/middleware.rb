# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module RaisesOnNotCheckedResultStatus
                class Middleware < MethodChainMiddleware
                  intended_for [
                    :data,
                    :message,
                    :code
                  ], entity: :result

                  def next(...)
                    assert_has_checked_status!

                    chain.next(...)
                  end

                  private

                  def assert_has_checked_status!
                    return if entity.internals.cache.exist?(:has_checked_status)

                    raise Errors::StatusIsNotChecked.new(attribute: method)
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

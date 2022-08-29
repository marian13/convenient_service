# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module RaisesOnNotCheckedResultStatus
                class Middleware < Core::MethodChainMiddleware
                  ##
                  # TODO: Replace to the following when support for Rubies lower than 2.7 is dropped.
                  #
                  #   def next(*args, **kwargs, &block)
                  #     # ...
                  #
                  #     chain.next(*args, **kwargs, &block)
                  #   end
                  #
                  # rubocop:disable Style/ArgumentsForwarding
                  def next(*args, **kwargs, &block)
                    assert_has_checked_status!

                    chain.next(*args, **kwargs, &block)
                  end
                  # rubocop:enable Style/ArgumentsForwarding

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

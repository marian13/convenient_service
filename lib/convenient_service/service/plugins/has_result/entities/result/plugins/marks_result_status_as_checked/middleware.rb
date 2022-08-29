# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module MarksResultStatusAsChecked
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
                    entity.internals.cache[:has_checked_status] = true

                    chain.next(*args, **kwargs, &block)
                  end
                  # rubocop:enable Style/ArgumentsForwarding
                end
              end
            end
          end
        end
      end
    end
  end
end

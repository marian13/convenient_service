# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                module Entities
                  class Status
                    module Plugins
                      module CanBeChecked
                        class Middleware < MethodChainMiddleware
                          intended_for [
                            :success?,
                            :failure?,
                            :error?,
                            :not_success?,
                            :not_failure?,
                            :not_error?
                          ],
                            entity: :result

                          ##
                          # @param args [Array<Object>]
                          # @param kwargs [Hash{Symbol => Object}]
                          # @param block [Proc, nil]
                          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                          #
                          def next(*args, **kwargs, &block)
                            mark_as_checked = kwargs.fetch(:mark_as_checked) { true }

                            entity.internals.cache[:checked] = true if mark_as_checked

                            chain.next(*args, **Utils::Hash.except(kwargs, [:mark_as_checked]), &block)
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
  end
end

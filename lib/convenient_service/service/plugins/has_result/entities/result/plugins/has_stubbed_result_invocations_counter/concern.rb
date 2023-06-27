# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasStubbedResultInvocationsCounter
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Support::ThreadSafeCounter]
                    #
                    def stubbed_result_invocations_counter
                      extra_kwargs[:stubbed_result_invocations_counter]
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

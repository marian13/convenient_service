# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasStubbedResultInvocationsCounter
                class Middleware < MethodChainMiddleware
                  intended_for :initialize, entity: :result

                  ##
                  # @param args [Array<Object>]
                  # @param kwargs [Hash{Symbol => Object}]
                  # @param block [Proc, nil]
                  # @return [void]
                  #
                  # @internal
                  #   NOTE: It is okish to assign to next method arguments here.
                  #   Since splat for `args` and double splat for `kwargs` always create new arrays and hashes respectively.
                  #   - https://github.com/ruby/spec/blob/c7ed8478a031d0df346d222495f4b4bbb298523b/language/keyword_arguments_spec.rb#L100
                  #
                  def next(*args, **kwargs, &block)
                    kwargs[:stubbed_result_invocations_counter] = Support::ThreadSafeCounter.new if kwargs[:stubbed_result]

                    chain.next(*args, **kwargs, &block)
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

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
              module CanHaveParentResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
                    #
                    # @internal
                    #   TODO: What if result is created from method step? Who is its parent?
                    #
                    def parent
                      Utils.memoize_including_falsy_values(self, :@parent) { extra_kwargs[:parent] }
                    end

                    ##
                    # @param include_self [Boolean]
                    # @param limit [Integer]
                    # @return [Array<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result>]
                    #
                    # @internal
                    #   Without enumerator `parents` method is roughly equivalent to the following code:
                    #
                    #   def parents(include_self: false)
                    #     parents = []
                    #
                    #     parents << self if include_self
                    #
                    #     ##
                    #     # NOTE: Empty parentheses are used to force a method call
                    #     # https://docs.ruby-lang.org/en/2.7.0/syntax/assignment_rdoc.html#label-Local+Variables+and+Methods
                    #     #
                    #     parent = parent()
                    #
                    #     while parent
                    #       parents << parent
                    #
                    #       parent = parent.parent
                    #     end
                    #
                    #     parents
                    #   end
                    #
                    def parents(include_self: false, limit: Constants::PARENTS_LIMIT)
                      parents_enum(include_self: include_self, limit: limit).to_a
                    end

                    ##
                    # @param include_self [Boolean]
                    # @param limit [Integer]
                    # @return [Enumerator<ConvenientService::Service::Plugins::HasJSendResult::Entities::Result>]
                    #
                    # @see https://ruby-doc.org/core-2.7.0/Enumerator.html
                    #
                    def parents_enum(include_self: false, limit: Constants::PARENTS_LIMIT)
                      ::Enumerator.new do |yielder|
                        yielder.yield(self) if include_self

                        ##
                        # NOTE: Empty parentheses are used to force a method call
                        # https://docs.ruby-lang.org/en/2.7.0/syntax/assignment_rdoc.html#label-Local+Variables+and+Methods
                        #
                        parent = parent()

                        ##
                        # NOTE: `finite_loop` is used to avoid even a theoretical infinite loop.
                        #
                        Support::FiniteLoop.finite_loop(max_iteration_count: limit, raise_on_exceedance: false) do
                          break unless parent

                          yielder.yield(parent)

                          parent = parent.parent
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

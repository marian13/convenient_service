# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveParentResult
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result, nil]
                    #
                    def parent
                      @parent ||= internals.cache[:parent]
                    end

                    ##
                    # @param include_self [Boolean]
                    # @return [Array<ConvenientService::Service::Plugins::HasResult::Entities::Result>]
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
                    def parents(include_self: false)
                      parents_enum(include_self: include_self).to_a
                    end

                    ##
                    # @param include_self [Boolean]
                    # @return [Enumerator<ConvenientService::Service::Plugins::HasResult::Entities::Result>]
                    #
                    # @see https://ruby-doc.org/core-2.7.0/Enumerator.html
                    #
                    def parents_enum(include_self: false)
                      ::Enumerator.new do |yielder|
                        yielder.yield(self) if include_self

                        ##
                        # NOTE: Empty parentheses are used to force a method call
                        # https://docs.ruby-lang.org/en/2.7.0/syntax/assignment_rdoc.html#label-Local+Variables+and+Methods
                        #
                        parent = parent()

                        while parent
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

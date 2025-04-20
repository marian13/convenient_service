# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              module Middlewares
                class Chain < Middlewares::Base
                  module Commands
                    class CreateObservableMiddleware < Support::Command
                      ##
                      # @!attribute [r] middleware
                      #   @return [Class]
                      #
                      attr_reader :middleware

                      ##
                      # @param middleware [Class]
                      # @return [void]
                      #
                      def initialize(middleware:)
                        @middleware = middleware
                      end

                      ##
                      # @return [Class]
                      #
                      def call
                        ::Class.new(middleware) do
                          class << self
                            def chain_class
                              ::Class.new(super) do
                                def initialize(**kwargs)
                                  arguments = Support::Arguments.new(**Utils::Hash.except(kwargs, [:middleware_events]))

                                  @__middleware_events__ = kwargs[:middleware_events]

                                  @__middleware_events__[:before_chain_initialize].notify_observers(arguments)

                                  super(**arguments.kwargs)

                                  @__middleware_events__[:after_chain_initialize].notify_observers(arguments)
                                end

                                def next(...)
                                  arguments = Support::Arguments.new(...)

                                  @__middleware_events__[:before_chain_next].notify_observers(arguments)

                                  value = super

                                  @__middleware_events__[:after_chain_next].notify_observers(value, arguments)

                                  value
                                end
                              end
                            end
                          end

                          def next(...)
                            arguments = Support::Arguments.new(...)

                            @__middleware_events__[:before_next].notify_observers(arguments)

                            value = super

                            @__middleware_events__[:after_next].notify_observers(value, arguments)

                            value
                          end

                          def chain
                            @__chain__ ||= self.class.chain_class.new(stack: @__stack__, middleware_events: @__middleware_events__)
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

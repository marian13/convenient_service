# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              class DefineMethodInContainer < Support::Command
                include Support::Delegate

                ##
                # @!attribute [r] method
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                #
                attr_reader :method

                ##
                # @!attribute [r] container
                #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                #
                attr_reader :container

                ##
                # @!attribute [r] index
                #   @return [Integer]
                #
                attr_reader :index

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Key]
                #
                delegate :key, to: :method

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Name]
                #
                delegate :name, to: :method

                ##
                # @param method [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @param container [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Service]
                # @param index [Integer]
                # @return [void]
                #
                def initialize(method:, container:, index:)
                  @method = method
                  @container = container
                  @index = index
                end

                ##
                # @return [Boolean]
                #
                # @internal
                #   IMPORTANT: Do NOT depend on `index` inside generated method. It breaks reassignments.
                #
                def call
                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    ##
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted]
                    #
                    def #{name}
                      internals.cache.scope(:step_output_values).fetch(__method__) do
                        ::ConvenientService.raise ::ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted.new(method_name: __method__)
                      end
                    end
                  RUBY

                  true
                end
              end
            end
          end
        end
      end
    end
  end
end

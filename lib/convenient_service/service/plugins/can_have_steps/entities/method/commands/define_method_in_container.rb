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
                # @return [Boolean] true if method is just defined, false if already defined.
                #
                def call
                  container.mutex.synchronize do
                    return false if has_defined_method?

                    define_method

                    true
                  end
                end

                private

                ##
                # @return [void]
                #
                def define_method
                  container.klass.alias_method name_before_out_redefinition.to_s, name.to_s if container.has_defined_method?(name)

                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    ##
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted]
                    #
                    # @internal
                    #   TODO: Direct specs.
                    #
                    def #{name}
                      return internals.cache.scope(:step_output_values).read(__method__) if internals.cache.scope(:step_output_values).exist?(__method__)

                      return #{name}_before_out_redefinition if respond_to?(:#{name}_before_out_redefinition)

                      ::ConvenientService.raise ::ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted.new(method_name: __method__)
                    end
                  RUBY
                end

                ##
                # @return [String]
                #
                def name_before_out_redefinition
                  "#{name}_before_out_redefinition"
                end

                ##
                # @return [Boolean]
                #
                def has_defined_method?
                  return false unless container.has_defined_method?(name)
                  return true if container.has_defined_method?(name_before_out_redefinition)

                  container.klass.instance_method(name.to_s).source_location.first.include?(__FILE__)
                end
              end
            end
          end
        end
      end
    end
  end
end

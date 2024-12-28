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
                  container.lock.synchronize do
                    return false if has_defined_method?

                    define_alias_method

                    define_method

                    true
                  end
                end

                private

                ##
                # @return [String]
                #
                def name
                  method.name.to_s
                end

                ##
                # @return [String]
                #
                def name_before_out_redefinition
                  @name_before_out_redefinition ||= Utils::Method::Name.append(name, "_before_out_redefinition")
                end

                ##
                # @return [Boolean]
                #
                def has_defined_method?
                  return false unless container.has_defined_method?(name)

                  return true if container.has_defined_method?(name_before_out_redefinition)

                  container.klass.instance_method(name).source_location.first.include?(__FILE__)
                end

                ##
                # @return [void]
                #
                def define_alias_method
                  return unless container.has_defined_method?(name)

                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    ##
                    # @return [Object] Can be any type.
                    #
                    alias_method :#{name_before_out_redefinition}, :#{name}
                  RUBY
                end

                ##
                # @return [void]
                #
                def define_method
                  <<~RUBY.tap { |code| container.klass.class_eval(code, __FILE__, __LINE__ + 1) }
                    ##
                    # @return [Object] Can be any type.
                    # @raise [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted]
                    #
                    def #{name}
                      return internals.cache.scope(:step_output_values).read(:#{name}) if internals.cache.scope(:step_output_values).exist?(:#{name})

                      return #{name_before_out_redefinition} if respond_to?(:#{name_before_out_redefinition}, true)

                      ::ConvenientService.raise ::ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Exceptions::OutMethodStepIsNotCompleted.new(method_name: :#{name})
                    end
                  RUBY
                end
              end
            end
          end
        end
      end
    end
  end
end

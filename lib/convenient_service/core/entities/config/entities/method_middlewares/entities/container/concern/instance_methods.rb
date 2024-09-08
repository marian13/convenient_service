# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Entities
              class Container
                module Concern
                  module InstanceMethods
                    include Support::Copyable
                    include Support::Delegate

                    ##
                    # @!attribute [r] klass
                    #   @return [Class]
                    #
                    attr_reader :klass

                    ##
                    # @!attribute [r] original_klass
                    #   @return [Class]
                    #
                    attr_reader :original_klass

                    ##
                    # @return [Array<Class, Module>]
                    #
                    delegate :ancestors, to: :klass

                    ##
                    # @param klass [Class]
                    # @return [void]
                    #
                    # @internal
                    #   NOTE: `klass` is the defining class. Sometimes it is the original class, sometimes it is the singleton class of the original class. It is done to have the same interface for method callers definition.
                    #   TODO: Rename `klass` to `defining_klass`.
                    #
                    def initialize(klass:, original_klass: klass)
                      @klass = klass
                      @original_klass = original_klass
                    end

                    ##
                    # @param method_name [Symbol, String]
                    # @return [UnboundMethod, nil]
                    #
                    def super_method_defined?(method_name)
                      Utils.to_bool(resolve_unbound_super_method(method_name))
                    end

                    ##
                    # Returns ancestors before the `methods_middlewares_callers` module. See the example below.
                    # When ancestors do NOT contain `methods_middlewares_callers`, returns an empty array.
                    #
                    # @return [Array<Class, Module>]
                    #
                    # @example The entity is an object.
                    #   class Service
                    #     include ConvenientService::Core
                    #
                    #     middlewares :result do
                    #       use ConvenientService::Plugins::Common::NormalizesEnv
                    #     end
                    #   end
                    #
                    #   entity = Service.new
                    #
                    #   entity.class.ancestors
                    #   # [Service::InstanceMethodsMiddlewaresCallers, Service, ConvenientService::Core::InstanceMethods, ConvenientService::Core, ConvenientService::Support::Concern, Object, Kernel, BasicObject]
                    #
                    #   ancestors_greater_than_methods_middlewares_callers # For the entity defined above.
                    #   # [Service, ConvenientService::Core::InstanceMethods, ConvenientService::Core, ConvenientService::Support::Concern, Object, Kernel, BasicObject]
                    #
                    # @example The entity is class.
                    #   class Service
                    #     include ConvenientService::Core
                    #
                    #     middlewares :result, scope: :class do
                    #       use ConvenientService::Plugins::Common::NormalizesEnv
                    #     end
                    #   end
                    #
                    #   entity = Service
                    #
                    #   entity.singleton_class.ancestors
                    #   # [Service::ClassMethodsMiddlewaresCallers, #<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
                    #
                    #   ancestors_greater_than_methods_middlewares_callers # For the entity defined above.
                    #   # [#<Class:Service>, ConvenientService::Core::ClassMethods, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
                    #
                    # @note Returns empty array when `methods_middlewares_callers` are NOT prepended.
                    # @note If you expect to receive not empty array, make sure the config is committed.
                    #
                    # @internal
                    #   NOTE: greater than -> futher in the inheritance chain than
                    #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-3E
                    #
                    #   NOTE: lower than -> closer in the inheritance chain than
                    #   https://ruby-doc.org/core-2.7.0/Module.html#method-i-ancestors
                    #
                    def ancestors_greater_than_methods_middlewares_callers
                      Utils::Array.keep_after(ancestors, methods_middlewares_callers)
                    end

                    ##
                    # @return [Module]
                    #
                    def methods_middlewares_callers
                      @methods_middlewares_callers ||= Commands::ResolveMethodsMiddlewaresCallers.call(container: self)
                    end

                    ##
                    # @return [Mutex]
                    #
                    def mutex
                      original_klass.mutex
                    end

                    ##
                    # @return [void]
                    #
                    def prepend_methods_callers_to_container
                      klass.prepend(methods_middlewares_callers)
                    end

                    ##
                    # @param method_name [Symbol, String]
                    # @return [UnboundMethod, nil]
                    #
                    # @note Returns `nil` when `methods_middlewares_callers` are NOT prepended.
                    # @note If you expect to receive not `nil`, make sure the config is committed.
                    #
                    def resolve_unbound_super_method(method_name)
                      Utils::Array.find_yield(ancestors_greater_than_methods_middlewares_callers) { |ancestor| Utils::Module.get_own_instance_method(ancestor, method_name, private: true) }
                    end

                    ##
                    # @param method_name [Symbol, String]
                    # @param entity [Class, Object]
                    # @return [Method, nil]
                    #
                    # @note Returns `nil` when `methods_middlewares_callers` are NOT prepended.
                    # @note If you expect to receive not `nil`, make sure the config is committed.
                    #
                    def resolve_super_method(method_name, entity)
                      unbound_super_method = resolve_unbound_super_method(method_name)

                      return unless unbound_super_method

                      unbound_super_method.bind(entity)
                    end

                    ##
                    # @param other [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container, Object]
                    # @return [Boolean, nil]
                    #
                    def ==(other)
                      return unless other.instance_of?(self.class)

                      return false if klass != other.klass
                      return false if original_klass != other.original_klass

                      true
                    end

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def to_kwargs
                      to_arguments.kwargs
                    end

                    ##
                    # @return [ConvenientService::Support::Arguments]
                    #
                    def to_arguments
                      Support::Arguments.new(klass: klass)
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

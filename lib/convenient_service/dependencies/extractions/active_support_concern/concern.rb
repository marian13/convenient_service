# frozen_string_literal: true

##
# @autor Rails Team <https://rubyonrails.org>
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
# @see https://github.com/rails/rails/blob/main/activesupport/lib/active_support/concern.rb
##

module ConvenientService
  module Dependencies
    module Extractions
      ##
      # @internal
      #   NOTE:
      #     Copied from `rails/rails` with some logic modification.
      #     Version: v7.0.4.3.
      #     Wrapped in a namespace `ConvenientService::Dependencies::Extractions::ActiveSupportConcern`.
      #     Added `instance_methods` that works in a similar way as `class_methods`.
      #     Added `singleton_class_methods` that works in a similar way as `class_methods`.
      #     Also `ClassMethods` (and `InstanceMethods`) are loaded after `included` block, not as in the original implementation.
      #     Added `eval_included_block` to have a template method.
      #     Added `eval_prepended_block` to have a template method.
      #
      #   - https://api.rubyonrails.org/v7.0.4.3/classes/ActiveSupport/Concern.html
      #   - https://github.com/rails/rails/blob/v7.0.4.3/activesupport/lib/active_support/concern.rb
      #   - https://github.com/marian13/rails/blob/v7.0.4.3/activesupport/lib/active_support/concern.rb
      #   - https://github.com/rails/rails
      #
      #   NOTE: It is ok that `MultipleIncludedBlocks` and `MultiplePrependBlocks` inherit from `StandardError` since dependencies are on the lower layer.
      #
      #   TODO: Move `Concern` to support? Rescue and reraise errors?
      #   - https://github.com/marian13/convenient_service/wiki/Design:-Communication-Graph
      #
      module ActiveSupportConcern
        ##
        # A typical module looks like this:
        #
        #   module M
        #     def self.included(base)
        #       base.extend ClassMethods
        #       base.class_eval do
        #         scope :disabled, -> { where(disabled: true) }
        #       end
        #     end
        #
        #     module ClassMethods
        #       ...
        #     end
        #   end
        #
        # By using <tt>ActiveSupport::Concern</tt> the above module could instead be
        # written as:
        #
        #   require "active_support/concern"
        #
        #   module M
        #     extend ActiveSupport::Concern
        #
        #     included do
        #       scope :disabled, -> { where(disabled: true) }
        #     end
        #
        #     class_methods do
        #       ...
        #     end
        #   end
        #
        # Moreover, it gracefully handles module dependencies. Given a +Foo+ module
        # and a +Bar+ module which depends on the former, we would typically write the
        # following:
        #
        #   module Foo
        #     def self.included(base)
        #       base.class_eval do
        #         def self.method_injected_by_foo
        #           ...
        #         end
        #       end
        #     end
        #   end
        #
        #   module Bar
        #     def self.included(base)
        #       base.method_injected_by_foo
        #     end
        #   end
        #
        #   class Host
        #     include Foo # We need to include this dependency for Bar
        #     include Bar # Bar is the module that Host really needs
        #   end
        #
        # But why should +Host+ care about +Bar+'s dependencies, namely +Foo+? We
        # could try to hide these from +Host+ directly including +Foo+ in +Bar+:
        #
        #   module Bar
        #     include Foo
        #     def self.included(base)
        #       base.method_injected_by_foo
        #     end
        #   end
        #
        #   class Host
        #     include Bar
        #   end
        #
        # Unfortunately this won't work, since when +Foo+ is included, its <tt>base</tt>
        # is the +Bar+ module, not the +Host+ class. With <tt>ActiveSupport::Concern</tt>,
        # module dependencies are properly resolved:
        #
        #   require "active_support/concern"
        #
        #   module Foo
        #     extend ActiveSupport::Concern
        #     included do
        #       def self.method_injected_by_foo
        #         ...
        #       end
        #     end
        #   end
        #
        #   module Bar
        #     extend ActiveSupport::Concern
        #     include Foo
        #
        #     included do
        #       self.method_injected_by_foo
        #     end
        #   end
        #
        #   class Host
        #     include Bar # It works, now Bar takes care of its dependencies
        #   end
        #
        # === Prepending concerns
        #
        # Just like <tt>include</tt>, concerns also support <tt>prepend</tt> with a corresponding
        # <tt>prepended do</tt> callback. <tt>module ClassMethods</tt> or <tt>class_methods do</tt> are
        # prepended as well.
        #
        # <tt>prepend</tt> is also used for any dependencies.
        module Concern
          class MultipleIncludedBlocks < StandardError # :nodoc:
            def initialize
              super "Cannot define multiple 'included' blocks for a Concern"
            end
          end

          class MultiplePrependBlocks < StandardError # :nodoc:
            def initialize
              super "Cannot define multiple 'prepended' blocks for a Concern"
            end
          end

          def self.extended(base) # :nodoc:
            base.instance_variable_set(:@_dependencies, [])
          end

          def append_features(base) # :nodoc:
            if base.instance_variable_defined?(:@_dependencies)
              base.instance_variable_get(:@_dependencies) << self
              false
            else
              return false if base < self
              @_dependencies.each { |dep| base.include(dep) }
              super

              eval_included_block(base)

              ##
              # NOTE: Customization compared to original `Concern` implementation.
              # TODO: Why original `Concern` implementation uses `const_defined?(:ClassMethods)`, not `const_defined?(:ClassMethods, false)`?
              # NOTE: Changed order to have a way to control when to include `InstanceMethods` and `ClassMethods` from `included` block.
              #
              base.include const_get(:InstanceMethods) if const_defined?(:InstanceMethods)

              base.extend const_get(:ClassMethods) if const_defined?(:ClassMethods)

              base.singleton_class.extend const_get(:SingletonClassMethods) if const_defined?(:SingletonClassMethods)
            end
          end

          def prepend_features(base) # :nodoc:
            if base.instance_variable_defined?(:@_dependencies)
              base.instance_variable_get(:@_dependencies).unshift self
              false
            else
              return false if base < self
              @_dependencies.each { |dep| base.prepend(dep) }
              super

              eval_prepended_block(base)

              ##
              # NOTE: Customization compared to original `Concern` implementation.
              # TODO: Why original `Concern` implementation uses `const_defined?(:ClassMethods)`, not `const_defined?(:ClassMethods, false)`?
              # NOTE: Changed order to have a way to control when to include `InstanceMethods` and `ClassMethods` from `included` block.
              #
              base.prepend const_get(:InstanceMethods) if const_defined?(:InstanceMethods)

              base.singleton_class.prepend const_get(:ClassMethods) if const_defined?(:ClassMethods)
            end
          end

          # Evaluate given block in context of base class,
          # so that you can write class macros here.
          # When you define more than one +included+ block, it raises an exception.
          def included(base = nil, &block)
            if base.nil?
              if instance_variable_defined?(:@_included_block)
                if @_included_block.source_location != block.source_location
                  raise MultipleIncludedBlocks
                end
              else
                @_included_block = block
              end
            else
              super
            end
          end

          # Evaluate given block in context of base class,
          # so that you can write class macros here.
          # When you define more than one +prepended+ block, it raises an exception.
          def prepended(base = nil, &block)
            if base.nil?
              if instance_variable_defined?(:@_prepended_block)
                if @_prepended_block.source_location != block.source_location
                  raise MultiplePrependBlocks
                end
              else
                @_prepended_block = block
              end
            else
              super
            end
          end

          ##
          # NOTE: Customization compared to original `Concern` implementation.
          #
          def instance_methods(include_private = false, &instance_methods_module_definition)
            ##
            # NOTE: This `if` is propably the reason why Rails team decided to create only `class_methods` in the original Concern implementation.
            #
            return super(include_private) unless instance_methods_module_definition

            mod = const_defined?(:InstanceMethods, false) ?
              const_get(:InstanceMethods) :
              const_set(:InstanceMethods, Module.new)

            mod.module_eval(&instance_methods_module_definition)
          end

          # Define class methods from given block.
          # You can define private class methods as well.
          #
          #   module Example
          #     extend ActiveSupport::Concern
          #
          #     class_methods do
          #       def foo; puts 'foo'; end
          #
          #       private
          #         def bar; puts 'bar'; end
          #     end
          #   end
          #
          #   class Buzz
          #     include Example
          #   end
          #
          #   Buzz.foo # => "foo"
          #   Buzz.bar # => private method 'bar' called for Buzz:Class(NoMethodError)
          def class_methods(&class_methods_module_definition)
            mod = const_defined?(:ClassMethods, false) ?
              const_get(:ClassMethods) :
              const_set(:ClassMethods, Module.new)

            mod.module_eval(&class_methods_module_definition)
          end

          # Define singleton class methods from given block.
          # You can define private class methods as well.
          #
          #   module Example
          #     extend ActiveSupport::Concern
          #
          #     singleton_class_methods do
          #       def foo; puts 'foo'; end
          #
          #       private
          #         def bar; puts 'bar'; end
          #     end
          #   end
          #
          #   class Buzz
          #     include Example
          #   end
          #
          #   Buzz.singleton_class.foo # => "foo"
          #   Buzz.singleton_class.bar # => private method 'bar' called for Buzz:Class(NoMethodError)
          def singleton_class_methods(&singleton_class_methods_module_definition)
            mod = const_defined?(:SingletonClassMethods, false) ?
              const_get(:SingletonClassMethods) :
              const_set(:SingletonClassMethods, Module.new)

            mod.module_eval(&singleton_class_methods_module_definition)
          end

          private

          ##
          # @param base [Class]
          # @return [void]
          #
          def eval_included_block(base)
            base.class_eval(&@_included_block) if instance_variable_defined?(:@_included_block)
          end

          ##
          # @param base [Class]
          # @return [void]
          #
          def eval_prepended_block(base)
            base.class_eval(&@_prepended_block) if instance_variable_defined?(:@_prepended_block)
          end
        end
      end
    end
  end
end

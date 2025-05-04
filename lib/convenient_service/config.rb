# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "config/commands"
require_relative "config/entities"
require_relative "config/exceptions"

module ConvenientService
  module Config
    ##
    # @param mod [Module]
    # @return [void]
    #
    def self.included(mod)
      mod.extend Dependencies::Extractions::ActiveSupportConcern::Concern

      mod.module_exec do
        class << self
          ##
          # @params klass [Class]
          # @return [void]
          #
          def eval_included_block(klass)
            klass.include ::ConvenientService::Core

            previous_options = klass.options.dup

            klass.options.replace(options)

            super
          ensure
            klass.options.replace(previous_options)
          end

          ##
          # @param options [Array<Symbol>]
          # @return [ConvenientService::Config]
          #
          def with(*options)
            dup.tap do |mod|
              mod.module_exec(base, self.options.dup.merge(options)) do |base, options|
                ##
                # @return [ConvenientService::Config]
                #
                define_singleton_method(:base) { base }

                ##
                # @return [Set]
                #
                define_singleton_method(:options) { options }
              end
            end
          end

          ##
          # @param options [Array<Symbol>]
          # @return [ConvenientService::Config]
          #
          def without(*options)
            dup.tap do |mod|
              mod.module_exec(base, self.options.dup.subtract(options)) do |base, options|
                ##
                # @return [ConvenientService::Config]
                #
                define_singleton_method(:base) { base }

                ##
                # @return [Set]
                #
                define_singleton_method(:options) { options }
              end
            end
          end

          ##
          # @return [ConvenientService::Config]
          #
          def with_defaults
            dup.tap do |mod|
              mod.module_exec(base, base.default_options) do |base, options|
                ##
                # @return [ConvenientService::Config]
                #
                define_singleton_method(:base) { base }

                ##
                # @return [Set]
                #
                define_singleton_method(:options) { options }
              end
            end
          end

          ##
          # @return [ConvenientService::Config]
          #
          def without_defaults
            dup.tap do |mod|
              mod.module_exec(base, Entities::Options.new) do |base, options|
                ##
                # @return [ConvenientService::Config]
                #
                define_singleton_method(:base) { base }

                ##
                # @return [Set]
                #
                define_singleton_method(:options) { options }
              end
            end
          end

          ##
          # @return [ConvenientService::Config]
          #
          def base
            self
          end

          ##
          # @return [ConvenientService::Config::Entities::Options]
          #
          def options
            @options ||= Entities::Options.new(options: default_options.dup)
          end

          ##
          # @param block [Proc, nil]
          # @return [ConvenientService::Config::Entities::Options]
          #
          def default_options(&block)
            block ? @default_options = Entities::Options.new(options: yield) : @default_options ||= Entities::Options.new
          end

          ##
          # @param other [Object] Can be any type.
          # @return [Boolean, nil]
          #
          def ==(other)
            return unless other.instance_of?(self.class)
            return false unless other.include?(::ConvenientService::Config)

            return false unless base.equal?(other.base)
            return false if options != other.options

            true
          end

          ##
          # @return [String]
          #
          def inspect
            name = base.name || "AnonymousConfig"

            options.any? ? "#{name}.with(#{options.map(&:inspect).join(", ")})" : name
          end
        end
      end
    end
  end
end

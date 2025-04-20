# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Support
    module DependencyContainer
      module Export
        include Support::Concern

        ##
        # @param klass [Class, Module]
        # @return [Module]
        #
        included do |klass|
          ::ConvenientService.raise Exceptions::NotModule.new(klass: klass) unless klass.instance_of?(::Module)
        end

        class_methods do
          ##
          # @param slug [String, Symbol]
          # @param scope [:instance, :class]
          # @param body [Proc]
          # @return [ConvenientService::Support::DependencyContainer::Entities::Method]
          #
          # @internal
          #   NOTE: `export` does NOT accept `prepend` kwarg intentionally.
          #   It is done to follow "the Ruby way".
          #   You won't ever see a module in Ruby that contains methods for `include` and `prepend` at the same time.
          #   So why `export` should allow to do it?
          #
          def export(slug, scope: Constants::DEFAULT_SCOPE, &body)
            Commands::AssertValidScope.call(scope: scope)

            Entities::Method.new(slug: slug, scope: scope, body: body).tap { |method| exported_methods << method }
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Entities::MethodCollection]
          #
          def exported_methods
            @exported_methods ||= Entities::MethodCollection.new
          end
        end
      end
    end
  end
end

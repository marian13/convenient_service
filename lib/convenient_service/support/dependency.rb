# frozen_string_literal: true

require_relative "dependency/commands"
require_relative "dependency/entities"
require_relative "dependency/errors"

module ConvenientService
  module Support
    ##
    # TODO: Specs.
    #
    module Dependency
      include Support::Concern

      instance_methods do
        ##
        # TODO: Specs.
        #
        def method_missing(method, *args, **kwargs, &block)
          dependencies = self.class.dependencies.select { |dependency| dependency.method == method }

          return super if dependencies.none?

          raise Errors::ProbablyNotSatisfiedDependency.new(dependencies: dependencies, object: self)
        end

        ##
        # TODO: Specs.
        #
        def respond_to_missing?(method_name, include_private = false)
          super
        end
      end

      ##
      #   dependency :copy, from: ConvenientService::Support::Copiable
      #
      class_methods do
        ##
        # TODO: Specs.
        #
        def dependency(*args, **kwargs)
          Entities::Dependency.new(*args, **kwargs).tap { |dependency| dependencies << dependency }
        end

        ##
        # TODO: Specs.
        #
        def dependencies(*args, **kwargs)
          @dependencies ||= Entities::DependencyCollection.new
        end
      end
    end
  end
end

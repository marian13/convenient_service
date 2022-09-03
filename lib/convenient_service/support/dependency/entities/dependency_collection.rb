# frozen_string_literal: true

module ConvenientService
  module Support
    module Dependency
      module Entities
        class DependencyCollection
          include ::Enumerable

          attr_reader :dependencies

          ##
          # TODO: Specs.
          #
          def initialize
            @dependencies = ::Set.new
          end

          ##
          # TODO: Specs.
          #
          def each(&block)
            dependencies.each(&block)
          end

          ##
          # TODO: Specs.
          # https://blog.appsignal.com/2018/05/29/ruby-magic-enumerable-and-enumerator.html
          #
          def select(&block)
            dependencies.select(&block)
          end

          ##
          # TODO: Specs.
          #
          def <<(dependency)
            dependencies << dependency
          end

          def ==(other)
            return unless other.instance_of?(self.class)

            return false if dependencies != other.dependencies

            true
          end
        end
      end
    end
  end
end

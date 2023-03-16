# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Method
            module Commands
              ##
              # TODO: Abstract factory.
              #
              class CastMethod < Support::Command
                attr_reader :other, :options

                def initialize(other:, options:)
                  @other = other
                  @options = options
                end

                def call
                  return unless key
                  return unless name
                  return unless caller
                  return unless direction

                  ##
                  # https://en.wikipedia.org/wiki/Composition_over_inheritance
                  #
                  Method.new(key: key, name: name, caller: caller, direction: direction)
                end

                private

                def key
                  @key ||= Commands::CastMethodKey.call(other: other, options: options)
                end

                def name
                  @name ||= Commands::CastMethodName.call(other: other, options: options)
                end

                def caller
                  @caller ||= Commands::CastMethodCaller.call(other: other, options: options)
                end

                def direction
                  @direction ||= Commands::CastMethodDirection.call(other: other, options: options)
                end
              end
            end
          end
        end
      end
    end
  end
end

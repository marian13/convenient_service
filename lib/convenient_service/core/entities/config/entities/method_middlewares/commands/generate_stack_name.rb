# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class MethodMiddlewares
            module Commands
              class GenerateStackName < Support::Command
                ##
                # @!attribute [r] scope
                #   @return [:instance, :class]
                #
                attr_reader :scope

                ##
                # @!attribute [r] method
                #   @return [Symbol, String]
                #
                attr_reader :method

                ##
                # @!attribute [r] container
                #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                #
                attr_reader :container

                ##
                # @param scope [:instance, :class]
                # @param method [Symbol, String]
                # @param container [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                # @return [void]
                #
                def initialize(scope:, method:, container:)
                  @method = method
                  @scope = scope
                  @container = container
                end

                ##
                # @return [String]
                #
                def call
                  "#{formatted_container}::MethodMiddlewares::#{formatted_scope}::#{formatted_method}"
                end

                ##
                # @return [String]
                #
                def formatted_container
                  container.klass
                end

                ##
                # @return [String]
                #
                def formatted_scope
                  Utils::String.camelize(scope)
                end

                ##
                # @return [String]
                #
                def formatted_method
                  "#{formatted_method_infix}#{formatted_method_suffix}"
                end

                ##
                # @return [String]
                #
                # @see https://www.britannica.com/topic/affix
                #
                def formatted_method_infix
                  Utils::String.camelize(method)
                end

                ##
                # @return [String]
                #
                def formatted_method_suffix
                  if method.end_with?("?")
                    "QuestionMark"
                  elsif method.end_with?("!")
                    "ExclamationMark"
                  else
                    ""
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

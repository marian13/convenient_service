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
            module Entities
              class Caller
                module Commands
                  class UndefineMethodCallers < Support::Command
                    include Support::Delegate

                    ##
                    # @!attribute [r] scope
                    #   @return [:instance, :class]
                    #
                    attr_reader :scope

                    ##
                    # @!attribute [r] method
                    #   @return [String, Symbol]
                    #
                    attr_reader :method

                    ##
                    # @!attribute [r] container
                    #   @return [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    #
                    attr_reader :container

                    ##
                    # @return [Module]
                    #
                    delegate :methods_middlewares_callers, to: :container

                    ##
                    # @param scope [:instance, :class]
                    # @param method [String, Symbol]
                    # @param container [ConvenientService::Core::Entities::Config::Entities::MethodMiddlewares::Entities::Container]
                    # @return [void]
                    #
                    def initialize(scope:, method:, container:)
                      @scope = scope
                      @method = method
                      @container = container
                    end

                    ##
                    # @return [Boolean] true if method middlewares caller is just undefined, false if already undefined.
                    #
                    def call
                      container.lock.synchronize do
                        return false unless Utils::Method.defined?(method, methods_middlewares_callers, private: true)

                        Utils::Method.remove(method, methods_middlewares_callers, private: true)
                        Utils::Method.remove(method_without_middlewares, methods_middlewares_callers, private: true)

                        true
                      end
                    end

                    private

                    ##
                    # @return [String]
                    #
                    def method_without_middlewares
                      @method_without_middlewares ||= Utils::Method::Name.append(method, "_without_middlewares")
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

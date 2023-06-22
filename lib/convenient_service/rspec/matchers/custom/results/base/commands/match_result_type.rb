# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultType < Support::Command
                include Support::DependencyContainer::Import

                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                import :"commands.is_result?", from: Service::Plugins::HasResult::Container

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @return [void]
                #
                def initialize(result:)
                  @result = result
                end

                ##
                # @return [Boolean]
                #
                def call
                  commands.is_result?(result)
                end
              end
            end
          end
        end
      end
    end
  end
end

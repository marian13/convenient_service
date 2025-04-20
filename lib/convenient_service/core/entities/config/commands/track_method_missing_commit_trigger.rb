# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Core
    module Entities
      class Config
        module Commands
          class TrackMethodMissingCommitTrigger < Support::Command
            ##
            # @!attribute [r] config
            #   @return [ConvenientService::Core::Entities::Config]
            #
            attr_reader :config

            ##
            # @!attribute [r] trigger
            #   @return [ConvenientService::Support::UniqueValue]
            #
            attr_reader :trigger

            ##
            # @param config [ConvenientService::Core::Entities::Config]
            # @param trigger [ConvenientService::Support::UniqueValue]
            # @return [void]
            #
            def initialize(config:, trigger:)
              @config = config
              @trigger = trigger
            end

            ##
            # @return [void]
            #
            def call
              return unless method_missing_trigger_valid?
              return if method_missing_commits_counter_incremented?

              ::ConvenientService.raise Exceptions::TooManyCommitsFromMethodMissing.new(config: config)
            end

            ##
            # @return [Boolean]
            #
            def method_missing_trigger_valid?
              method_missing_triggers.any?(trigger)
            end

            ##
            # @return [Boolean]
            #
            def method_missing_commits_counter_incremented?
              Utils.memoize_including_falsy_values(self, :@method_missing_commits_counter_incremented) { config.method_missing_commits_counter.bincrement }
            end

            ##
            # @return [Array<ConvenientService::Support::UniqueValue>]
            #
            def method_missing_triggers
              @method_missing_triggers ||= [
                Constants::Triggers::INSTANCE_METHOD_MISSING,
                Constants::Triggers::CLASS_METHOD_MISSING
              ]
            end
          end
        end
      end
    end
  end
end

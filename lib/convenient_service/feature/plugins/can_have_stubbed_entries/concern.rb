# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Feature
    module Plugins
      module CanHaveStubbedEntries
        module Concern
          include Support::Concern

          included do
            extend ClassMethods

            ##
            # IMPORTANT:
            #   - Initializes `stubbed_entries` during the `include Concern` process.
            #   - Tries to enforce thread-safety in such a way.
            #   - https://github.com/ruby/spec/blob/master/core/module/include_spec.rb
            #   - https://github.com/ruby/ruby/blob/master/class.c
            #
            stubbed_entries
          end

          class_methods do
            ##
            # @return [ConvenientService::Support::Cache]
            #
            # @internal
            #   NOTE: `self` is a feature class in the current context. For example:
            #
            #   before do
            #     stub_entry(ConvenientService::Examples::Standard::Gemfile, :format)
            #       .without_arguments
            #       .to return_value(42)
            #   end
            #
            #   # Then `self` is `ConvenientService::Examples::Standard::Gemfile`.
            #
            def stubbed_entries
              Commands::FetchFeatureStubbedEntriesCache.call(feature: self)
            end

            ##
            # @param entry_name [Symbol, String]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureStub]
            #
            def stub_entry(entry_name)
              Entities::FeatureStub.new(feature_class: self, entry_name: entry_name)
            end

            ##
            # @param entry_name [Symbol, String]
            # @return [ConvenientService::Feature::Plugins::CanHaveStubbedEntries::Entities::FeatureUnstub]
            #
            def unstub_entry(entry_name)
              Entities::FeatureUnstub.new(feature_class: self, entry_name: entry_name)
            end
          end
        end
      end
    end
  end
end
